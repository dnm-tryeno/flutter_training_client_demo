/**
 * Monthly Home, Room, Apartment & Property Rental Platform
 * Central State Engine, Business Rules Enforcement & Storage Manager
 */

class AppState {
  constructor() {
    this.STORAGE_KEY = 'rentease_rental_platform_db_v1';
    this.CURRENT_ROLE_KEY = 'rentease_current_role_v1';
    this.CURRENT_USER_KEY = 'rentease_current_user_id_v1';
    this.CURRENT_VIEW_MODE_KEY = 'rentease_view_mode_v1'; // 'mobile' or 'desktop'
    this.AUTH_STATUS_KEY = 'rentease_auth_status_v1';

    this.listeners = [];
    this.data = this.loadDatabase();
    this.isAuthenticated = localStorage.getItem(this.AUTH_STATUS_KEY) === 'true';
    this.currentRole = localStorage.getItem(this.CURRENT_ROLE_KEY) || 'CUSTOMER'; // 'CUSTOMER' | 'OWNER' | 'ADMIN'
    this.currentUserId = localStorage.getItem(this.CURRENT_USER_KEY) || 'cust_1';
    this.viewMode = localStorage.getItem(this.CURRENT_VIEW_MODE_KEY) || 'mobile'; // mobile-first toggle

    // Current Customer Search / Filter State
    this.searchFilters = {
      areaType: 'all', // 'all', 'urban', 'rural'
      city: '',
      locality: '',
      propertyType: '',
      suitableFor: [],
      maxRent: 50000,
      minRent: 0,
      furnishing: 'all',
      onlyAvailable: true,
      searchQuery: ''
    };

    // Ensure database integrity and check reminders on init
    this.checkAndGenerateRentReminders();
  }

  loadDatabase() {
    try {
      const stored = localStorage.getItem(this.STORAGE_KEY);
      if (stored) {
        return JSON.parse(stored);
      }
    } catch (e) {
      console.error('Failed to load database from localStorage, initializing default seed.', e);
    }
    const seed = window.INITIAL_DATABASE ? JSON.parse(JSON.stringify(window.INITIAL_DATABASE)) : {};
    this.saveDatabase(seed);
    return seed;
  }

  saveDatabase(dataToSave = this.data) {
    try {
      localStorage.setItem(this.STORAGE_KEY, JSON.stringify(dataToSave));
    } catch (e) {
      console.error('Failed to persist database to localStorage', e);
    }
  }

  resetToDefaultSeed() {
    if (window.INITIAL_DATABASE) {
      this.data = JSON.parse(JSON.stringify(window.INITIAL_DATABASE));
      this.saveDatabase();
      this.notifyListeners();
    }
  }

  subscribe(listener) {
    this.listeners.push(listener);
    return () => {
      this.listeners = this.listeners.filter(l => l !== listener);
    };
  }

  notifyListeners(changeType = 'GENERAL_UPDATE') {
    this.saveDatabase();
    this.listeners.forEach(fn => fn(changeType, this));
  }

  // --- User & Role Management ---

  setRole(role, userId = null) {
    this.currentRole = role;
    localStorage.setItem(this.CURRENT_ROLE_KEY, role);

    if (userId) {
      this.currentUserId = userId;
      localStorage.setItem(this.CURRENT_USER_KEY, userId);
    } else {
      // Pick sensible default for role
      if (role === 'CUSTOMER') {
        const cust = this.data.users.find(u => u.role === 'CUSTOMER');
        this.currentUserId = cust ? cust.id : 'cust_1';
      } else if (role === 'OWNER') {
        const owner = this.data.users.find(u => u.role === 'OWNER');
        this.currentUserId = owner ? owner.id : 'owner_1';
      } else if (role === 'ADMIN') {
        this.currentUserId = 'admin_1';
      }
      localStorage.setItem(this.CURRENT_USER_KEY, this.currentUserId);
    }

    this.notifyListeners('ROLE_CHANGED');
  }

  setCurrentUser(userId) {
    const user = this.data.users.find(u => u.id === userId);
    if (user) {
      this.currentUserId = user.id;
      this.currentRole = user.role;
      localStorage.setItem(this.CURRENT_USER_KEY, user.id);
      localStorage.setItem(this.CURRENT_ROLE_KEY, user.role);
      this.notifyListeners('USER_CHANGED');
    }
  }

  getCurrentUser() {
    let user = this.data.users.find(u => u.id === this.currentUserId);
    if (!user) {
      user = this.data.users[0];
      this.currentUserId = user.id;
    }
    return user;
  }

  login(role, userId = null) {
    this.isAuthenticated = true;
    localStorage.setItem(this.AUTH_STATUS_KEY, 'true');
    this.setRole(role, userId);
    this.notifyListeners('AUTH_LOGIN');
  }

  logout() {
    this.isAuthenticated = false;
    localStorage.setItem(this.AUTH_STATUS_KEY, 'false');
    this.notifyListeners('AUTH_LOGOUT');
  }

  setViewMode(mode) {
    this.viewMode = mode;
    localStorage.setItem(this.CURRENT_VIEW_MODE_KEY, mode);
    this.notifyListeners('VIEW_MODE_CHANGED');
  }

  // --- Customer Search & Filter Logic ---

  setSearchFilters(partialFilters) {
    this.searchFilters = { ...this.searchFilters, ...partialFilters };
    this.notifyListeners('SEARCH_UPDATED');
  }

  resetSearchFilters() {
    this.searchFilters = {
      areaType: 'all',
      city: '',
      locality: '',
      propertyType: '',
      suitableFor: [],
      maxRent: 50000,
      minRent: 0,
      furnishing: 'all',
      onlyAvailable: true,
      searchQuery: ''
    };
    this.notifyListeners('SEARCH_RESET');
  }

  /**
   * Returns list of flattened property rooms matching search criteria & availability rules.
   * Rule 1: Customer sees only available properties.
   * Rule 2: Rented properties cannot be requested by another customer.
   * Rule 6: Customer eligibility must match property's "Suitable For" settings.
   */
  getSearchResults() {
    const results = [];
    const f = this.searchFilters;

    for (const prop of this.data.properties) {
      // Area type filter (Urban / Rural)
      if (f.areaType !== 'all' && prop.areaType !== f.areaType) continue;

      // City filter
      if (f.city && f.city !== '' && prop.city.toLowerCase() !== f.city.toLowerCase()) continue;

      // Locality / Village filter
      if (f.locality && f.locality !== '' && prop.locality.toLowerCase() !== f.locality.toLowerCase()) continue;

      // Property Type filter
      if (f.propertyType && f.propertyType !== '' && prop.propertyType !== f.propertyType) continue;

      // General search query string across title, address, description, locality
      if (f.searchQuery && f.searchQuery.trim() !== '') {
        const q = f.searchQuery.toLowerCase().trim();
        const matchesProp =
          prop.title.toLowerCase().includes(q) ||
          prop.address.toLowerCase().includes(q) ||
          prop.locality.toLowerCase().includes(q) ||
          prop.city.toLowerCase().includes(q) ||
          prop.description.toLowerCase().includes(q);

        if (!matchesProp) {
          // Check if any room matches
          const roomMatch = prop.rooms.some(r => r.roomNumber.toLowerCase().includes(q) || r.roomType.toLowerCase().includes(q));
          if (!roomMatch) continue;
        }
      }

      // Check rooms inside property
      for (const room of prop.rooms) {
        // Availability Rule: Rented properties hidden from search
        if (f.onlyAvailable) {
          if (room.status === 'Rented' || room.status === 'Not Available') {
            continue;
          }
        }

        // Rent Budget filter
        if (room.monthlyRent > f.maxRent || room.monthlyRent < f.minRent) continue;

        // Furnishing filter
        if (f.furnishing !== 'all') {
          const furnLower = room.furnishing.toLowerCase();
          if (f.furnishing === 'furnished' && !furnLower.includes('fully') && !furnLower.includes('furnished')) continue;
          if (f.furnishing === 'semi' && !furnLower.includes('semi')) continue;
          if (f.furnishing === 'unfurnished' && !furnLower.includes('unfurnished')) continue;
        }

        // Suitable For / Customer Type filter (Mandatory Rule 5 & 6)
        // If customer filtered for specific suitable types, room MUST support at least one of selected types
        let isSuitable = true;
        let suitabilityMatch = [];
        if (f.suitableFor && f.suitableFor.length > 0) {
          suitabilityMatch = f.suitableFor.filter(type => room.suitableFor.includes(type));
          if (suitabilityMatch.length === 0) {
            isSuitable = false;
          }
        }

        if (isSuitable) {
          const owner = this.data.users.find(u => u.id === prop.ownerId);
          results.push({
            property: prop,
            room: room,
            owner: owner,
            matchedSuitableTypes: suitabilityMatch
          });
        }
      }
    }

    return results;
  }

  // --- Property & Multi-Room Details ---

  getPropertyRoomById(propertyId, roomId) {
    const prop = this.data.properties.find(p => p.id === propertyId);
    if (!prop) return null;
    const room = prop.rooms.find(r => r.id === roomId) || prop.rooms[0];
    const owner = this.data.users.find(u => u.id === prop.ownerId);
    return { property: prop, room: room, owner: owner };
  }

  toggleSaveProperty(propRoomId) {
    const idx = this.data.savedProperties.indexOf(propRoomId);
    if (idx > -1) {
      this.data.savedProperties.splice(idx, 1);
    } else {
      this.data.savedProperties.push(propRoomId);
    }
    this.notifyListeners('SAVED_PROPERTIES_UPDATED');
  }

  isPropertySaved(propRoomId) {
    return this.data.savedProperties.includes(propRoomId);
  }

  // --- Owner Privacy Rules (Rule 4 & 5 & Section 9) ---
  /**
   * Determines if Customer can call or message the Owner
   */
  getOwnerContactPermissions(ownerId) {
    const owner = this.data.users.find(u => u.id === ownerId);
    if (!owner) return { canCall: false, canMessage: false, setting: 'BOTH_OFF' };

    const setting = owner.contactSettings || 'CALL_MSG_ON';
    switch (setting) {
      case 'CALL_MSG_ON':
        return { canCall: true, canMessage: true, setting, phone: owner.mobile, email: owner.email };
      case 'CALL_ON_MSG_OFF':
        return { canCall: true, canMessage: false, setting, phone: owner.mobile, email: null };
      case 'CALL_OFF_MSG_ON':
        return { canCall: false, canMessage: true, setting, phone: null, email: owner.email };
      case 'BOTH_OFF':
      default:
        return { canCall: false, canMessage: false, setting, phone: null, email: null };
    }
  }

  updateOwnerContactSettings(ownerId, setting) {
    const owner = this.data.users.find(u => u.id === ownerId);
    if (owner) {
      owner.contactSettings = setting;
      this.notifyListeners('OWNER_SETTINGS_UPDATED');
    }
  }

  // --- Rental Request & Terms Workflow (Sections 10, 11, 12, 13) ---

  createRentalRequest({ propertyId, roomId, expectedMoveInDate, rentalPeriodMonths, requirements }) {
    const cust = this.getCurrentUser();
    const propDetails = this.getPropertyRoomById(propertyId, roomId);
    if (!propDetails) throw new Error('Property or Room not found');

    const { property, room, owner } = propDetails;

    if (room.status === 'Rented') {
      throw new Error('This room is already rented and cannot accept new rental requests.');
    }

    const newReq = {
      id: 'req_' + Date.now(),
      customerId: cust.id,
      propertyId: property.id,
      roomId: room.id,
      ownerId: owner.id,
      expectedMoveInDate: expectedMoveInDate,
      rentalPeriodMonths: parseInt(rentalPeriodMonths, 10) || 11,
      customerDetails: {
        name: cust.name,
        mobile: cust.mobile,
        customerType: cust.customerType || 'single',
        aadhaarVerified: cust.aadhaarVerified || false
      },
      requirements: requirements || '',
      status: 'Pending',
      createdAt: new Date().toISOString(),
      termsConfirmedByOwner: false,
      termsConfirmedByCustomer: false
    };

    // Update room status
    room.status = 'Rental Request';

    this.data.rentalRequests.unshift(newReq);

    // Notify Owner
    this.addNotification({
      recipientId: owner.id,
      recipientRole: 'OWNER',
      title: 'New Rental Request Received',
      message: `${cust.name} requested to rent ${room.roomNumber} in ${property.title}. Move-in date: ${expectedMoveInDate}.`,
      type: 'RENTAL_REQUEST'
    });

    this.notifyListeners('RENTAL_REQUEST_CREATED');
    return newReq;
  }

  ownerRespondToRequest(requestId, decision) {
    // decision: 'ACCEPT' | 'REJECT'
    const req = this.data.rentalRequests.find(r => r.id === requestId);
    if (!req) return;

    const propDetails = this.getPropertyRoomById(req.propertyId, req.roomId);

    if (decision === 'ACCEPT') {
      req.status = 'Accepted';
      req.termsConfirmedByOwner = true;
      if (propDetails && propDetails.room) {
        propDetails.room.status = 'Agreement Pending';
      }

      this.addNotification({
        recipientId: req.customerId,
        recipientRole: 'CUSTOMER',
        title: 'Rental Request Accepted!',
        message: `Owner has accepted your rental request for ${propDetails ? propDetails.property.title : 'the property'}. Please confirm final terms & KYC.`,
        type: 'REQUEST_ACCEPTED'
      });
    } else {
      req.status = 'Rejected';
      if (propDetails && propDetails.room) {
        propDetails.room.status = 'Available';
      }

      this.addNotification({
        recipientId: req.customerId,
        recipientRole: 'CUSTOMER',
        title: 'Rental Request Update',
        message: `Your rental request was not accepted at this time. The property remains available for other queries.`,
        type: 'REQUEST_REJECTED'
      });
    }

    this.notifyListeners('REQUEST_STATUS_UPDATED');
  }

  customerConfirmTerms(requestId) {
    const req = this.data.rentalRequests.find(r => r.id === requestId);
    if (!req) return;

    req.termsConfirmedByCustomer = true;
    this.notifyListeners('TERMS_CONFIRMED');
  }

  // --- Aadhaar Legal e-KYC & Agreement Finalization (Section 13) ---

  performAadhaarKYC(userId, aadhaarNumber, otpCode) {
    // Simulated legal/KYC provider endpoint
    if (!aadhaarNumber || aadhaarNumber.replace(/\D/g, '').length !== 12) {
      throw new Error('Please enter a valid 12-digit Aadhaar Number');
    }
    if (otpCode !== '123456' && otpCode.length !== 6) {
      throw new Error('Invalid OTP. For demo/testing use OTP: 123456');
    }

    const user = this.data.users.find(u => u.id === userId);
    if (user) {
      user.aadhaarVerified = true;
      user.aadhaarLast4 = aadhaarNumber.slice(-4);
      this.notifyListeners('KYC_COMPLETED');
      return true;
    }
    return false;
  }

  completeRentalAgreement(requestId) {
    const req = this.data.rentalRequests.find(r => r.id === requestId);
    if (!req) throw new Error('Request not found');

    const propDetails = this.getPropertyRoomById(req.propertyId, req.roomId);
    if (!propDetails) throw new Error('Property not found');

    const { property, room, owner } = propDetails;
    const cust = this.data.users.find(u => u.id === req.customerId);

    // Create Agreement Record
    const agreementId = 'agr_' + Date.now();
    const newAgreement = {
      id: agreementId,
      requestId: req.id,
      customerId: cust.id,
      ownerId: owner.id,
      propertyId: property.id,
      roomId: room.id,
      status: 'Agreement Completed',
      aadhaarVerified: true,
      verificationService: 'UIDAI e-KYC Legal Sandbox Service',
      verificationDate: new Date().toISOString().split('T')[0],
      monthlyRent: room.monthlyRent,
      securityDeposit: room.securityDeposit,
      otherCharges: 0,
      moveInDate: req.expectedMoveInDate,
      dueDayOfMonth: room.dueDayOfMonth || 5,
      rentalConditions: property.rentalConditions,
      customerConsent: true,
      ownerConsent: true,
      signedAt: new Date().toISOString()
    };
    this.data.agreements.unshift(newAgreement);

    // Create Active Rental Record (Section 19)
    const activeRentalId = 'rent_act_' + Date.now();
    const activeRental = {
      id: activeRentalId,
      agreementId: agreementId,
      customerId: cust.id,
      ownerId: owner.id,
      propertyId: property.id,
      roomId: room.id,
      monthlyRent: room.monthlyRent,
      securityDeposit: room.securityDeposit,
      rentStartDate: req.expectedMoveInDate,
      monthlyDueDay: room.dueDayOfMonth || 5,
      status: 'Active',
      propertySnapshot: {
        title: property.title,
        roomNumber: room.roomNumber,
        address: property.address
      }
    };
    this.data.activeRentals.unshift(activeRental);

    // Update Room & Property Status (Rule 7 & 18: Available -> Rented)
    room.status = 'Rented';
    room.currentTenantId = cust.id;
    room.activeRentalId = activeRentalId;

    // Generate First Month Rent Record automatically (Section 17 & 19)
    const now = new Date();
    const monthNames = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
    const currentMonthStr = `${monthNames[now.getMonth()]} ${now.getFullYear()}`;

    const newPayment = {
      id: 'pay_' + Date.now(),
      rentalId: activeRentalId,
      customerId: cust.id,
      ownerId: owner.id,
      propertyId: property.id,
      roomId: room.id,
      rentMonth: currentMonthStr,
      rentAmount: room.monthlyRent,
      dueDate: `${now.getFullYear()}-${String(now.getMonth() + 1).padStart(2, '0')}-${String(room.dueDayOfMonth || 5).padStart(2, '0')}`,
      paymentDate: null,
      paymentMode: null,
      paymentStatus: 'Pending',
      transactionRef: null,
      receiptNumber: null,
      notes: `Initial monthly rent due on move-in`,
      createdDate: new Date().toISOString()
    };
    this.data.rentPayments.unshift(newPayment);

    // Notifications
    this.addNotification({
      recipientId: cust.id,
      recipientRole: 'CUSTOMER',
      title: 'Agreement Completed! Welcome to your new home 🎉',
      message: `Your rental agreement for ${property.title} (${room.roomNumber}) is now active. Monthly rent ₹${room.monthlyRent.toLocaleString('en-IN')}.`,
      type: 'AGREEMENT_COMPLETED'
    });

    this.addNotification({
      recipientId: owner.id,
      recipientRole: 'OWNER',
      title: 'Agreement Signed & Room Rented!',
      message: `${cust.name} has completed the verification and rented ${room.roomNumber}. Active rental created.`,
      type: 'AGREEMENT_COMPLETED'
    });

    this.notifyListeners('AGREEMENT_COMPLETED');
    return { agreement: newAgreement, activeRental };
  }

  // --- Rent Payment Processing & Ledger (Sections 19, 20, 21, 22, 23, 25) ---

  recordRentPayment({ paymentId, paymentMode, transactionRef, notes, paidByOwnerDirect = false }) {
    const payment = this.data.rentPayments.find(p => p.id === paymentId);
    if (!payment) throw new Error('Rent payment record not found');

    const now = new Date();
    const formattedDate = now.toISOString().split('T')[0];
    const receiptNum = `REC-${now.getFullYear()}-${String(now.getMonth() + 1).padStart(2, '0')}-${Math.floor(100 + Math.random() * 900)}`;

    payment.paymentStatus = 'Paid';
    payment.paymentDate = formattedDate;
    payment.paymentMode = paymentMode; // 'Cash' | 'UPI' | 'Online' | 'Bank Transfer'
    payment.transactionRef = transactionRef || (paymentMode === 'Cash' ? `CASH-REC-${Math.floor(1000 + Math.random() * 9000)}` : `TXN-${Date.now()}`);
    payment.receiptNumber = receiptNum;
    if (notes) payment.notes = notes;

    // Send notifications to both Customer and Owner
    this.addNotification({
      recipientId: payment.customerId,
      recipientRole: 'CUSTOMER',
      title: 'Rent Payment Successful',
      message: `Rent of ₹${payment.rentAmount.toLocaleString('en-IN')} for ${payment.rentMonth} marked as Paid via ${paymentMode}. Receipt #${receiptNum} generated.`,
      type: 'RENT_PAID'
    });

    this.addNotification({
      recipientId: payment.ownerId,
      recipientRole: 'OWNER',
      title: 'Rent Payment Recorded',
      message: `Rent of ₹${payment.rentAmount.toLocaleString('en-IN')} for ${payment.rentMonth} received via ${paymentMode}.`,
      type: 'RENT_PAID'
    });

    this.notifyListeners('RENT_PAYMENT_RECORDED');
    return payment;
  }

  // --- Add Property (Owner App - Section 15 & 16) ---

  addProperty(propertyData) {
    const owner = this.getCurrentUser();
    const newPropId = 'prop_' + Date.now();
    const newRoomId = 'room_' + Date.now();

    const requiresApproval = propertyData.approvalStatus || (this.data.settings?.rental?.requirePropertyApproval !== false ? 'Pending Approval' : 'Approved');

    const newProperty = {
      id: newPropId,
      ownerId: owner.id,
      title: propertyData.title,
      propertyType: propertyData.propertyType,
      areaType: propertyData.areaType, // 'urban' | 'rural'
      city: propertyData.city,
      locality: propertyData.locality,
      address: propertyData.address,
      approvalStatus: requiresApproval,
      isMultiRoom: propertyData.isMultiRoom || false,
      featured: false,
      rating: 5.0,
      reviewsCount: 1,
      image: propertyData.image || 'https://images.unsplash.com/photo-1545324418-cc1a3fa10c00?auto=format&fit=crop&w=800&q=80',
      gallery: [
        propertyData.image || 'https://images.unsplash.com/photo-1545324418-cc1a3fa10c00?auto=format&fit=crop&w=800&q=80'
      ],
      description: propertyData.description,
      electricityInfo: propertyData.electricityInfo || 'Sub-meter installed. Billed as per government tariff.',
      maintenanceInfo: propertyData.maintenanceInfo || 'Common area maintenance included.',
      otherCharges: propertyData.otherCharges || 'None',
      rentalConditions: propertyData.rentalConditions || 'Standard 11-month rental agreement with 1-month notice.',
      amenities: propertyData.amenities || ['Power Backup', 'Water Supply', 'Wi-Fi Ready', 'Security'],
      rooms: [
        {
          id: newRoomId,
          propertyId: newPropId,
          roomNumber: propertyData.roomNumber || 'Unit 101',
          roomType: propertyData.roomType || propertyData.propertyType,
          sizeSqFt: propertyData.sizeSqFt || '500 sq.ft',
          furnishing: propertyData.furnishing || 'Semi-Furnished',
          monthlyRent: parseInt(propertyData.monthlyRent, 10) || 10000,
          securityDeposit: parseInt(propertyData.securityDeposit, 10) || 20000,
          dueDayOfMonth: parseInt(propertyData.dueDayOfMonth, 10) || 5,
          availableFrom: propertyData.availableFrom || new Date().toISOString().split('T')[0],
          status: requiresApproval === 'Approved' ? 'Available' : 'Pending Approval',
          suitableFor: propertyData.suitableFor && propertyData.suitableFor.length > 0 ? propertyData.suitableFor : ['single', 'working_professional', 'family'],
          featuredImage: propertyData.image || 'https://images.unsplash.com/photo-1545324418-cc1a3fa10c00?auto=format&fit=crop&w=800&q=80'
        }
      ]
    };

    // If owner passed extra rooms (multi-room property)
    if (propertyData.extraRooms && Array.isArray(propertyData.extraRooms)) {
      propertyData.extraRooms.forEach((exRoom, idx) => {
        newProperty.rooms.push({
          id: 'room_' + Date.now() + '_' + (idx + 1),
          propertyId: newPropId,
          roomNumber: exRoom.roomNumber || `Room ${idx + 2}`,
          roomType: exRoom.roomType || 'room',
          sizeSqFt: exRoom.sizeSqFt || '350 sq.ft',
          furnishing: exRoom.furnishing || 'Furnished',
          monthlyRent: parseInt(exRoom.monthlyRent, 10) || 8000,
          securityDeposit: parseInt(exRoom.securityDeposit, 10) || 16000,
          dueDayOfMonth: parseInt(propertyData.dueDayOfMonth, 10) || 5,
          availableFrom: exRoom.availableFrom || new Date().toISOString().split('T')[0],
          status: requiresApproval === 'Approved' ? 'Available' : 'Pending Approval',
          suitableFor: exRoom.suitableFor || propertyData.suitableFor,
          featuredImage: exRoom.image || newProperty.image
        });
      });
    }

    this.data.properties.unshift(newProperty);

    this.addNotification({
      recipientId: owner.id,
      recipientRole: 'OWNER',
      title: requiresApproval === 'Pending Approval' ? 'Property Submitted for Approval' : 'Property Listed Successfully',
      message: requiresApproval === 'Pending Approval' 
        ? `${newProperty.title} is submitted and awaiting administrative review.`
        : `${newProperty.title} is now active and listed on the rental marketplace.`,
      type: 'PROPERTY_ADDED'
    });


    this.notifyListeners('PROPERTY_ADDED');
    return newProperty;
  }

  // --- Add Room to Existing Property ---

  addRoomToProperty(propertyId, roomData) {
    const prop = this.data.properties.find(p => p.id === propertyId);
    if (!prop) throw new Error('Property not found');

    const newRoom = {
      id: 'room_' + Date.now(),
      propertyId: prop.id,
      roomNumber: roomData.roomNumber || `Room ${prop.rooms.length + 1}`,
      roomType: roomData.roomType || 'room',
      sizeSqFt: roomData.sizeSqFt || '400 sq.ft',
      furnishing: roomData.furnishing || 'Semi-Furnished',
      monthlyRent: parseInt(roomData.monthlyRent, 10) || 8000,
      securityDeposit: parseInt(roomData.securityDeposit, 10) || 16000,
      dueDayOfMonth: parseInt(roomData.dueDayOfMonth, 10) || 5,
      availableFrom: roomData.availableFrom || new Date().toISOString().split('T')[0],
      status: 'Available',
      suitableFor: roomData.suitableFor || ['single', 'students', 'working_professional'],
      featuredImage: roomData.image || prop.image
    };

    prop.rooms.push(newRoom);
    prop.isMultiRoom = true;

    this.notifyListeners('ROOM_ADDED');
    return newRoom;
  }

  // --- Edit & Delete Property (CRUD) ---
  editProperty(propertyId, updatedData) {
    const prop = this.data.properties.find(p => p.id === propertyId);
    if (!prop) throw new Error('Property not found');

    if (updatedData.title) prop.title = updatedData.title;
    if (updatedData.propertyType) prop.propertyType = updatedData.propertyType;
    if (updatedData.areaType) prop.areaType = updatedData.areaType;
    if (updatedData.city) prop.city = updatedData.city;
    if (updatedData.locality) prop.locality = updatedData.locality;
    if (updatedData.address) prop.address = updatedData.address;
    if (updatedData.electricityInfo) prop.electricityInfo = updatedData.electricityInfo;
    if (updatedData.maintenanceInfo) prop.maintenanceInfo = updatedData.maintenanceInfo;

    if (updatedData.monthlyRent && prop.rooms.length > 0) {
      prop.rooms[0].monthlyRent = parseInt(updatedData.monthlyRent, 10);
    }
    if (updatedData.securityDeposit && prop.rooms.length > 0) {
      prop.rooms[0].securityDeposit = parseInt(updatedData.securityDeposit, 10);
    }
    if (updatedData.roomNumber && prop.rooms.length > 0) {
      prop.rooms[0].roomNumber = updatedData.roomNumber;
    }
    if (updatedData.furnishing && prop.rooms.length > 0) {
      prop.rooms[0].furnishing = updatedData.furnishing;
    }

    this.addAuditLog({
      action: 'UPDATE',
      module: 'PROPERTIES',
      recordId: propertyId,
      oldValue: 'Previous property details',
      newValue: `Updated property: ${prop.title}`
    });

    this.notifyListeners('PROPERTY_UPDATED');
    return prop;
  }

  deleteProperty(propertyId) {
    const idx = this.data.properties.findIndex(p => p.id === propertyId);
    if (idx === -1) throw new Error('Property not found');

    const title = this.data.properties[idx].title;
    this.data.properties.splice(idx, 1);

    this.addAuditLog({
      action: 'DELETE',
      module: 'PROPERTIES',
      recordId: propertyId,
      oldValue: `Deleted: ${title}`,
      newValue: 'REMOVED'
    });

    this.notifyListeners('PROPERTY_DELETED');
    return true;
  }

  // --- Customer CRUD ---
  adminAddCustomer(customerData) {
    const newCust = {
      id: 'cust_' + Date.now(),
      name: customerData.name,
      mobile: customerData.mobile,
      email: customerData.email || `${customerData.name.toLowerCase().replace(/\s+/g, '')}@example.com`,
      role: 'CUSTOMER',
      customerType: customerData.customerType || 'Single',
      aadhaarVerified: customerData.aadhaarVerified !== false,
      aadhaarLast4: customerData.aadhaarLast4 || '4512',
      status: 'Active',
      createdAt: new Date().toISOString().split('T')[0],
      address: customerData.address || 'Varanasi, UP'
    };

    this.data.users.push(newCust);

    this.addAuditLog({
      action: 'CREATE',
      module: 'CUSTOMERS',
      recordId: newCust.id,
      oldValue: null,
      newValue: `Added customer: ${newCust.name} (${newCust.mobile})`
    });

    this.notifyListeners('USER_ADDED');
    return newCust;
  }

  adminEditCustomer(customerId, updatedData) {
    const cust = this.data.users.find(u => u.id === customerId);
    if (!cust) throw new Error('Customer not found');

    if (updatedData.name) cust.name = updatedData.name;
    if (updatedData.mobile) cust.mobile = updatedData.mobile;
    if (updatedData.email) cust.email = updatedData.email;
    if (updatedData.customerType) cust.customerType = updatedData.customerType;
    if (typeof updatedData.aadhaarVerified === 'boolean') cust.aadhaarVerified = updatedData.aadhaarVerified;
    if (updatedData.status) cust.status = updatedData.status;

    this.addAuditLog({
      action: 'UPDATE',
      module: 'CUSTOMERS',
      recordId: customerId,
      oldValue: 'Previous details',
      newValue: `Updated customer: ${cust.name}`
    });

    this.notifyListeners('USER_UPDATED');
    return cust;
  }

  adminDeleteCustomer(customerId) {
    const idx = this.data.users.findIndex(u => u.id === customerId);
    if (idx === -1) throw new Error('Customer not found');

    const name = this.data.users[idx].name;
    this.data.users.splice(idx, 1);

    this.addAuditLog({
      action: 'DELETE',
      module: 'CUSTOMERS',
      recordId: customerId,
      oldValue: `Deleted customer: ${name}`,
      newValue: 'REMOVED'
    });

    this.notifyListeners('USER_DELETED');
    return true;
  }

  // --- Owner CRUD ---
  adminAddOwner(ownerData) {
    const newOwner = {
      id: 'owner_' + Date.now(),
      name: ownerData.name,
      mobile: ownerData.mobile,
      email: ownerData.email || `${ownerData.name.toLowerCase().replace(/\s+/g, '')}@example.com`,
      role: 'OWNER',
      status: 'Active',
      contactSettings: ownerData.contactSettings || 'CALL_MSG_ON',
      createdAt: new Date().toISOString().split('T')[0],
      propertiesCount: parseInt(ownerData.propertiesCount, 10) || 1
    };

    this.data.users.push(newOwner);

    this.addAuditLog({
      action: 'CREATE',
      module: 'OWNERS',
      recordId: newOwner.id,
      oldValue: null,
      newValue: `Added landlord: ${newOwner.name} (${newOwner.mobile})`
    });

    this.notifyListeners('USER_ADDED');
    return newOwner;
  }

  adminEditOwner(ownerId, updatedData) {
    const owner = this.data.users.find(u => u.id === ownerId);
    if (!owner) throw new Error('Owner not found');

    if (updatedData.name) owner.name = updatedData.name;
    if (updatedData.mobile) owner.mobile = updatedData.mobile;
    if (updatedData.email) owner.email = updatedData.email;
    if (updatedData.contactSettings) owner.contactSettings = updatedData.contactSettings;
    if (updatedData.status) owner.status = updatedData.status;

    this.addAuditLog({
      action: 'UPDATE',
      module: 'OWNERS',
      recordId: ownerId,
      oldValue: 'Previous details',
      newValue: `Updated landlord: ${owner.name}`
    });

    this.notifyListeners('USER_UPDATED');
    return owner;
  }

  adminDeleteOwner(ownerId) {
    const idx = this.data.users.findIndex(u => u.id === ownerId);
    if (idx === -1) throw new Error('Owner not found');

    const name = this.data.users[idx].name;
    this.data.users.splice(idx, 1);

    this.addAuditLog({
      action: 'DELETE',
      module: 'OWNERS',
      recordId: ownerId,
      oldValue: `Deleted landlord: ${name}`,
      newValue: 'REMOVED'
    });

    this.notifyListeners('USER_DELETED');
    return true;
  }

  // --- Automatic Rent Reminder System (Section 24) ---

  checkAndGenerateRentReminders() {
    const today = new Date();
    const currentDay = today.getDate();

    for (const rental of this.data.activeRentals) {
      if (rental.status !== 'Active') continue;

      const dueDay = rental.monthlyDueDay || 5;
      const pendingPay = this.data.rentPayments.find(
        p => p.rentalId === rental.id && p.paymentStatus === 'Pending'
      );

      if (pendingPay) {
        // Condition 1: 3-5 days before due date
        if (dueDay - currentDay >= 1 && dueDay - currentDay <= 4) {
          this.ensureReminderExists({
            recipientId: rental.customerId,
            recipientRole: 'CUSTOMER',
            type: 'RENT_REMINDER_UPCOMING',
            title: 'Upcoming Monthly Rent Reminder',
            message: `Your monthly rent of ₹${rental.monthlyRent.toLocaleString('en-IN')} for ${rental.propertySnapshot.title} is due on ${dueDay} of this month.`
          });
        }
        // Condition 2: On due date
        else if (currentDay === dueDay) {
          this.ensureReminderExists({
            recipientId: rental.customerId,
            recipientRole: 'CUSTOMER',
            type: 'RENT_REMINDER_DUE_TODAY',
            title: 'Rent Due Today ⏰',
            message: `Your monthly rent of ₹${rental.monthlyRent.toLocaleString('en-IN')} for ${rental.propertySnapshot.title} is due today.`
          });
          this.ensureReminderExists({
            recipientId: rental.ownerId,
            recipientRole: 'OWNER',
            type: 'RENT_REMINDER_OWNER',
            title: 'Rent Due Today from Tenant',
            message: `Rent for ${rental.propertySnapshot.title} (${rental.propertySnapshot.roomNumber}) is due today from tenant.`
          });
        }
        // Condition 3: After due date (Overdue)
        else if (currentDay > dueDay) {
          this.ensureReminderExists({
            recipientId: rental.customerId,
            recipientRole: 'CUSTOMER',
            type: 'RENT_REMINDER_OVERDUE',
            title: 'Monthly Rent Payment Overdue ⚠️',
            message: `Your monthly rent payment of ₹${rental.monthlyRent.toLocaleString('en-IN')} is pending past the due date (${dueDay}th). Please clear at the earliest.`
          });
          this.ensureReminderExists({
            recipientId: rental.ownerId,
            recipientRole: 'OWNER',
            type: 'RENT_REMINDER_OWNER_OVERDUE',
            title: 'Tenant Rent Pending Past Due Date',
            message: `Rent payment for ${rental.propertySnapshot.roomNumber} is pending past ${dueDay}th of this month.`
          });
        }
      }
    }
  }

  ensureReminderExists({ recipientId, recipientRole, type, title, message }) {
    const todayStr = new Date().toISOString().split('T')[0];
    const existing = this.data.notifications.find(
      n => n.recipientId === recipientId && n.type === type && n.createdAt.startsWith(todayStr)
    );
    if (!existing) {
      this.addNotification({ recipientId, recipientRole, title, message, type });
    }
  }

  // --- Notifications ---

  addNotification({ recipientId, recipientRole, title, message, type }) {
    const notif = {
      id: 'notif_' + Date.now() + '_' + Math.floor(Math.random() * 100),
      recipientId,
      recipientRole,
      title,
      message,
      type: type || 'SYSTEM',
      read: false,
      createdAt: new Date().toISOString()
    };
    this.data.notifications.unshift(notif);
    this.saveDatabase();
    return notif;
  }

  markNotificationAsRead(notifId) {
    const notif = this.data.notifications.find(n => n.id === notifId);
    if (notif) {
      notif.read = true;
      this.notifyListeners('NOTIFICATIONS_UPDATED');
    }
  }

  getNotificationsForUser(userId) {
    return this.data.notifications.filter(n => n.recipientId === userId || n.recipientId === 'ALL');
  }

  getUnreadNotificationsCount(userId) {
    return this.getNotificationsForUser(userId).filter(n => !n.read).length;
  }

  // --- Complaints & Support (Section 26, 27, 28) ---

  submitComplaint({ propertyId, propertyTitle, category, subject, description }) {
    const user = this.getCurrentUser();
    const newComplaint = {
      id: 'comp_' + Date.now(),
      userId: user.id,
      userName: user.name,
      userRole: user.role,
      propertyId: propertyId || '',
      propertyTitle: propertyTitle || 'General Inquiry',
      category: category || 'Maintenance',
      subject: subject,
      description: description,
      status: 'Open',
      adminResponse: null,
      createdAt: new Date().toISOString()
    };
    this.data.complaints.unshift(newComplaint);

    this.addNotification({
      recipientId: 'admin_1',
      recipientRole: 'ADMIN',
      title: 'New Complaint Filed',
      message: `${user.name} filed a complaint under "${category}": ${subject}`,
      type: 'COMPLAINT_FILED'
    });

    this.notifyListeners('COMPLAINT_SUBMITTED');
    return newComplaint;
  }

  adminRespondComplaint(complaintId, responseText, newStatus = 'Resolved') {
    const comp = this.data.complaints.find(c => c.id === complaintId);
    if (comp) {
      comp.adminResponse = responseText;
      comp.status = newStatus;

      this.addNotification({
        recipientId: comp.userId,
        recipientRole: comp.userRole,
        title: 'Support Update on Ticket #' + comp.id.slice(-6),
        message: `Admin Response: "${responseText}" (Status: ${newStatus})`,
        type: 'COMPLAINT_RESOLVED'
      });

      this.notifyListeners('COMPLAINT_UPDATED');
    }
  }

  // --- Admin Analytics & Statistics (Section 2 & 28) ---

  getAdminStatistics(dateRange = 'THIS_MONTH', customStart = null, customEnd = null) {
    const totalCustomers = this.data.users.filter(u => u.role === 'CUSTOMER').length;
    const totalOwners = this.data.users.filter(u => u.role === 'OWNER').length;
    const totalProperties = this.data.properties.length;

    let totalRooms = 0;
    let availableRooms = 0;
    let rentedRooms = 0;
    let pendingRequestRooms = 0;

    for (const prop of this.data.properties) {
      for (const room of prop.rooms) {
        totalRooms++;
        if (room.status === 'Available') availableRooms++;
        else if (room.status === 'Rented') rentedRooms++;
        else if (room.status === 'Rental Request' || room.status === 'Agreement Pending') pendingRequestRooms++;
      }
    }

    const pendingApprovals = this.data.properties.filter(p => p.approvalStatus === 'Pending Approval').length;
    const pendingRequests = this.data.rentalRequests.filter(r => r.status === 'Pending').length;
    const completedAgreements = this.data.agreements.filter(a => a.status === 'Agreement Completed').length;
    const activeRentals = this.data.activeRentals.filter(r => r.status === 'Active').length;

    let totalRentCollected = 0;
    let totalPendingRent = 0;
    let totalTransactions = 0;
    const paymentModeCounts = { Cash: 0, UPI: 0, Online: 0, 'Bank Transfer': 0 };

    for (const pay of this.data.rentPayments) {
      if (pay.paymentStatus === 'Paid') {
        totalRentCollected += pay.rentAmount;
        totalTransactions++;
        if (pay.paymentMode) {
          paymentModeCounts[pay.paymentMode] = (paymentModeCounts[pay.paymentMode] || 0) + pay.rentAmount;
        }
      } else if (pay.paymentStatus === 'Pending') {
        totalPendingRent += pay.rentAmount;
      }
    }

    const openComplaints = this.data.complaints.filter(c => c.status !== 'Resolved' && c.status !== 'Closed').length;
    const occupancyRate = totalRooms > 0 ? Math.round((rentedRooms / totalRooms) * 100) : 0;

    // Monthly collection trend breakdown
    const monthlyTrends = [
      { month: 'Jul 2026', collected: 45000, pending: 5000 },
      { month: 'Aug 2026', collected: 52000, pending: 8000 },
      { month: 'Sep 2026', collected: 64000, pending: 12000 },
      { month: 'Oct 2026', collected: totalRentCollected, pending: totalPendingRent }
    ];

    return {
      totalCustomers,
      totalOwners,
      totalProperties,
      totalRooms,
      availableRooms,
      rentedRooms,
      pendingPropertyApprovals: pendingApprovals,
      pendingRentalRequests: pendingRequests,
      completedAgreements,
      activeRentals,
      totalRentCollected,
      totalPendingRent,
      totalComplaints: this.data.complaints.length,
      openComplaints,
      occupancyRate,
      totalTransactions,
      paymentModeCounts,
      monthlyTrends,
      dateRange
    };
  }

  // --- Admin Authentication & Session (Section 1) ---

  adminLogin({ email, password, otp }) {
    const admin = this.data.adminUsers.find(a => (a.email.toLowerCase() === email.toLowerCase() || a.mobile === email) && a.status === 'Active');
    if (!admin) {
      throw new Error('Invalid Admin credentials or account inactive.');
    }
    // In production password hash verification, simulated test password check
    if (password !== 'admin123' && password !== 'Admin@2026') {
      throw new Error('Incorrect password. (Test Admin Password: admin123)');
    }

    this.currentUserId = admin.id;
    this.currentRole = 'ADMIN';
    admin.lastLogin = new Date().toLocaleString();
    this.addAuditLog({
      action: 'ADMIN_LOGIN',
      module: 'Security',
      recordId: admin.id,
      oldValue: 'Logged Out',
      newValue: 'Authenticated'
    });

    this.notifyListeners('ADMIN_LOGGED_IN');
    return admin;
  }

  adminLogout() {
    this.addAuditLog({
      action: 'ADMIN_LOGOUT',
      module: 'Security',
      recordId: this.currentUserId,
      oldValue: 'Authenticated',
      newValue: 'Logged Out'
    });
    this.setRole('CUSTOMER', 'cust_1');
  }

  // --- Audit Logging (Section 23) ---

  addAuditLog({ action, module, recordId, oldValue, newValue }) {
    const admin = this.data.adminUsers?.find(a => a.id === this.currentUserId) || { name: 'Super Administrator' };
    const log = {
      id: 'audit_' + Date.now() + '_' + Math.floor(Math.random() * 100),
      adminName: admin.name,
      action,
      module,
      recordId: String(recordId || ''),
      oldValue: String(oldValue || ''),
      newValue: String(newValue || ''),
      timestamp: new Date().toISOString().replace('T', ' ').substring(0, 19),
      ipAddress: '192.168.1.24'
    };
    if (!this.data.auditLogs) this.data.auditLogs = [];
    this.data.auditLogs.unshift(log);
    return log;
  }

  // --- Property Approval & Management Workflow (Section 6 & 10) ---

  adminApproveProperty(propertyId) {
    const prop = this.data.properties.find(p => p.id === propertyId);
    if (prop) {
      const oldStatus = prop.approvalStatus || 'Pending Approval';
      prop.approvalStatus = 'Approved';
      prop.rooms.forEach(r => {
        if (r.status === 'Pending Approval' || r.status === 'Not Available') r.status = 'Available';
      });

      this.addAuditLog({
        action: 'PROPERTY_APPROVED',
        module: 'Properties',
        recordId: prop.id,
        oldValue: oldStatus,
        newValue: 'Approved & Available'
      });

      this.addNotification({
        recipientId: prop.ownerId,
        recipientRole: 'OWNER',
        title: 'Property Approved! 🎉',
        message: `Your property "${prop.title}" has been approved by admin and is now live for rent.`,
        type: 'PROPERTY_APPROVED'
      });

      this.notifyListeners('PROPERTY_APPROVED');
    }
  }

  adminRejectProperty(propertyId, reason) {
    const prop = this.data.properties.find(p => p.id === propertyId);
    if (prop) {
      prop.approvalStatus = 'Rejected';
      prop.rejectionReason = reason;
      prop.rooms.forEach(r => r.status = 'Not Available');

      this.addAuditLog({
        action: 'PROPERTY_REJECTED',
        module: 'Properties',
        recordId: prop.id,
        oldValue: 'Pending Approval',
        newValue: `Rejected (${reason})`
      });

      this.addNotification({
        recipientId: prop.ownerId,
        recipientRole: 'OWNER',
        title: 'Property Listing Update',
        message: `Listing for "${prop.title}" was not approved: ${reason}`,
        type: 'PROPERTY_REJECTED'
      });

      this.notifyListeners('PROPERTY_REJECTED');
    }
  }

  adminTogglePropertyAvailability(propertyId, roomId = null) {
    const prop = this.data.properties.find(p => p.id === propertyId);
    if (prop) {
      if (roomId) {
        const r = prop.rooms.find(rm => rm.id === roomId);
        if (r && r.status !== 'Rented') {
          const oldVal = r.status;
          r.status = r.status === 'Available' ? 'Not Available' : 'Available';
          this.addAuditLog({
            action: 'UNIT_AVAILABILITY_CHANGED',
            module: 'Properties',
            recordId: `${prop.id}:${r.id}`,
            oldValue: oldVal,
            newValue: r.status
          });
        }
      } else {
        const oldVal = prop.approvalStatus;
        prop.approvalStatus = prop.approvalStatus === 'Approved' ? 'Deactivated' : 'Approved';
        this.addAuditLog({
          action: 'PROPERTY_STATUS_TOGGLED',
          module: 'Properties',
          recordId: prop.id,
          oldValue: oldVal,
          newValue: prop.approvalStatus
        });
      }
      this.notifyListeners('PROPERTY_UPDATED');
    }
  }

  // --- Customer / Owner Activation & Management (Section 4 & 5) ---

  adminToggleUserStatus(userId) {
    const user = this.data.users.find(u => u.id === userId);
    if (user) {
      const oldVal = user.status || 'Active';
      user.status = oldVal === 'Active' ? 'Deactivated' : 'Active';

      this.addAuditLog({
        action: 'USER_STATUS_TOGGLED',
        module: user.role === 'CUSTOMER' ? 'Customers' : 'Owners',
        recordId: user.id,
        oldValue: oldVal,
        newValue: user.status
      });

      this.notifyListeners('USER_STATUS_CHANGED');
    }
  }

  adminUpdateUser(userId, updatedData) {
    const user = this.data.users.find(u => u.id === userId);
    if (user) {
      Object.assign(user, updatedData);
      this.addAuditLog({
        action: 'USER_PROFILE_UPDATED',
        module: user.role === 'CUSTOMER' ? 'Customers' : 'Owners',
        recordId: user.id,
        oldValue: 'Profile Info',
        newValue: 'Updated Details'
      });
      this.notifyListeners('USER_UPDATED');
    }
  }

  adminGetCustomerProfile(customerId) {
    const customer = this.data.users.find(u => u.id === customerId);
    const activeRental = this.data.activeRentals.find(r => r.customerId === customerId && r.status === 'Active');
    const requests = this.data.rentalRequests.filter(r => r.customerId === customerId);
    const agreements = this.data.agreements.filter(a => a.customerId === customerId);
    const payments = this.data.rentPayments.filter(p => p.customerId === customerId);
    const complaints = this.data.complaints.filter(c => c.userId === customerId);

    return { customer, activeRental, requests, agreements, payments, complaints };
  }

  adminGetOwnerProfile(ownerId) {
    const owner = this.data.users.find(u => u.id === ownerId);
    const properties = this.data.properties.filter(p => p.ownerId === ownerId);
    const requests = this.data.rentalRequests.filter(r => r.ownerId === ownerId);
    const activeRentals = this.data.activeRentals.filter(r => r.ownerId === ownerId && r.status === 'Active');
    const payments = this.data.rentPayments.filter(p => p.ownerId === ownerId);
    const complaints = this.data.complaints.filter(c => c.userId === ownerId);

    let totalCollected = 0;
    let totalPending = 0;
    payments.forEach(p => {
      if (p.paymentStatus === 'Paid') totalCollected += p.rentAmount;
      else totalPending += p.rentAmount;
    });

    return { owner, properties, requests, activeRentals, payments, complaints, totalCollected, totalPending };
  }

  // --- Property Types CRUD (Section 7) ---

  adminAddPropertyType({ name, icon, description }) {
    const id = name.toLowerCase().replace(/[^a-z0-9]/g, '_');
    const newType = { id, name, icon: icon || '🏠', description: description || '', active: true };
    this.data.propertyTypes.push(newType);

    this.addAuditLog({
      action: 'PROPERTY_TYPE_ADDED',
      module: 'Property Types',
      recordId: id,
      oldValue: '',
      newValue: name
    });

    this.notifyListeners('PROPERTY_TYPES_UPDATED');
    return newType;
  }

  adminUpdatePropertyType(typeId, { name, icon, description, active }) {
    const t = this.data.propertyTypes.find(pt => pt.id === typeId);
    if (t) {
      if (name) t.name = name;
      if (icon) t.icon = icon;
      if (description !== undefined) t.description = description;
      if (active !== undefined) t.active = active;

      this.addAuditLog({
        action: 'PROPERTY_TYPE_UPDATED',
        module: 'Property Types',
        recordId: typeId,
        oldValue: 'Old Type',
        newValue: t.name
      });
      this.notifyListeners('PROPERTY_TYPES_UPDATED');
    }
  }

  adminDeletePropertyType(typeId) {
    // Check if any property uses this type
    const dependentProps = this.data.properties.filter(p => p.propertyType === typeId);
    if (dependentProps.length > 0) {
      throw new Error(`Cannot delete category "${typeId}". It is currently used by ${dependentProps.length} properties.`);
    }

    const idx = this.data.propertyTypes.findIndex(pt => pt.id === typeId);
    if (idx !== -1) {
      const removed = this.data.propertyTypes.splice(idx, 1)[0];
      this.addAuditLog({
        action: 'PROPERTY_TYPE_DELETED',
        module: 'Property Types',
        recordId: typeId,
        oldValue: removed.name,
        newValue: 'Deleted'
      });
      this.notifyListeners('PROPERTY_TYPES_UPDATED');
    }
  }

  // --- Suitable For Categories CRUD (Section 8) ---

  adminAddSuitableForCategory({ name, badgeColor }) {
    const id = name.toLowerCase().replace(/[^a-z0-9]/g, '_');
    const newCat = { id, name, badgeColor: badgeColor || '#0ea5e9', active: true };
    this.data.customerTypes.push(newCat);

    this.addAuditLog({
      action: 'SUITABLE_CATEGORY_ADDED',
      module: 'Suitable For',
      recordId: id,
      oldValue: '',
      newValue: name
    });

    this.notifyListeners('SUITABLE_CATEGORIES_UPDATED');
    return newCat;
  }

  adminUpdateSuitableForCategory(catId, { name, badgeColor, active }) {
    const cat = this.data.customerTypes.find(c => c.id === catId);
    if (cat) {
      if (name) cat.name = name;
      if (badgeColor) cat.badgeColor = badgeColor;
      if (active !== undefined) cat.active = active;

      this.addAuditLog({
        action: 'SUITABLE_CATEGORY_UPDATED',
        module: 'Suitable For',
        recordId: catId,
        oldValue: 'Old Category',
        newValue: cat.name
      });
      this.notifyListeners('SUITABLE_CATEGORIES_UPDATED');
    }
  }

  adminDeleteSuitableForCategory(catId) {
    const idx = this.data.customerTypes.findIndex(c => c.id === catId);
    if (idx !== -1) {
      const removed = this.data.customerTypes.splice(idx, 1)[0];
      this.addAuditLog({
        action: 'SUITABLE_CATEGORY_DELETED',
        module: 'Suitable For',
        recordId: catId,
        oldValue: removed.name,
        newValue: 'Deleted'
      });
      this.notifyListeners('SUITABLE_CATEGORIES_UPDATED');
    }
  }

  // --- Area Hierarchy Management (Section 9) ---

  adminAddUrbanLocality(city, locality) {
    let foundCity = this.data.areas.urban.find(c => c.city.toLowerCase() === city.toLowerCase());
    if (!foundCity) {
      foundCity = { city, localities: [] };
      this.data.areas.urban.push(foundCity);
    }
    if (!foundCity.localities.includes(locality)) {
      foundCity.localities.push(locality);
    }

    this.addAuditLog({
      action: 'AREA_LOCALITY_ADDED',
      module: 'Areas (Urban)',
      recordId: city,
      oldValue: '',
      newValue: locality
    });

    this.notifyListeners('AREAS_UPDATED');
  }

  adminAddRuralVillage(district, village) {
    let foundDist = this.data.areas.rural.find(r => r.district.toLowerCase() === district.toLowerCase());
    if (!foundDist) {
      foundDist = { district, villages: [] };
      this.data.areas.rural.push(foundDist);
    }
    if (!foundDist.villages.includes(village)) {
      foundDist.villages.push(village);
    }

    this.addAuditLog({
      action: 'VILLAGE_ADDED',
      module: 'Areas (Rural)',
      recordId: district,
      oldValue: '',
      newValue: village
    });

    this.notifyListeners('AREAS_UPDATED');
  }

  adminDeleteUrbanLocality(city, locality) {
    const foundCity = this.data.areas.urban.find(c => c.city.toLowerCase() === city.toLowerCase());
    if (foundCity) {
      foundCity.localities = foundCity.localities.filter(l => l !== locality);
      this.addAuditLog({
        action: 'LOCALITY_DELETED',
        module: 'Areas (Urban)',
        recordId: city,
        oldValue: locality,
        newValue: 'Removed'
      });
      this.notifyListeners('AREAS_UPDATED');
    }
  }

  adminDeleteRuralVillage(district, village) {
    const foundDist = this.data.areas.rural.find(r => r.district.toLowerCase() === district.toLowerCase());
    if (foundDist) {
      foundDist.villages = foundDist.villages.filter(v => v !== village);
      this.addAuditLog({
        action: 'VILLAGE_DELETED',
        module: 'Areas (Rural)',
        recordId: district,
        oldValue: village,
        newValue: 'Removed'
      });
      this.notifyListeners('AREAS_UPDATED');
    }
  }

  // --- Monthly Rent Management (Section 14, 15, 16) ---

  adminGetRentTimeline(customerId, rentalId = null) {
    let payments = this.data.rentPayments.filter(p => p.customerId === customerId);
    if (rentalId) {
      payments = payments.filter(p => p.rentalId === rentalId);
    }
    return payments.sort((a, b) => (b.rentMonth > a.rentMonth ? 1 : -1));
  }

  // --- Rent Reminder Management (Section 17) ---

  adminSendRentReminder(rentalId, type = 'Payment Pending', channel = 'In-App + SMS Integration') {
    const rental = this.data.activeRentals.find(r => r.id === rentalId);
    if (!rental) throw new Error('Active rental not found.');

    const tenant = this.data.users.find(u => u.id === rental.customerId);
    const prop = this.data.properties.find(p => p.id === rental.propertyId);

    // Check duplicate scheduled for same day
    const todayStr = new Date().toISOString().substring(0, 10);
    const existing = this.data.reminders?.find(r => r.rentalId === rentalId && r.sentAt?.includes(todayStr) && r.type === type);
    if (existing) {
      throw new Error(`A reminder for this rental (${type}) has already been sent today.`);
    }

    const newRem = {
      id: 'rem_' + Date.now(),
      rentalId: rental.id,
      tenantName: tenant ? tenant.name : 'Tenant',
      propertyTitle: prop ? `${prop.title} (${rental.propertySnapshot?.roomNumber || 'Room'})` : 'Rental Property',
      amount: rental.propertySnapshot?.monthlyRent || 0,
      dueDate: `2026-10-${String(rental.dueDayOfMonth || 5).padStart(2, '0')}`,
      type,
      channel,
      status: 'Delivered',
      sentAt: new Date().toISOString().replace('T', ' ').substring(0, 19)
    };

    if (!this.data.reminders) this.data.reminders = [];
    this.data.reminders.unshift(newRem);

    this.addNotification({
      recipientId: rental.customerId,
      recipientRole: 'CUSTOMER',
      title: `Rent Reminder: ${type}`,
      message: `Your monthly rent of ₹${newRem.amount.toLocaleString('en-IN')} for ${newRem.propertyTitle} is due on ${newRem.dueDate}.`,
      type: 'RENT_REMINDER'
    });

    this.addAuditLog({
      action: 'RENT_REMINDER_DISPATCHED',
      module: 'Rent Reminders',
      recordId: rental.id,
      oldValue: '',
      newValue: `${type} via ${channel}`
    });

    this.notifyListeners('REMINDER_SENT');
    return newRem;
  }

  // --- Reports Data Generator & CSV Export (Section 21) ---

  adminGenerateReport(reportType, filters = {}) {
    switch (reportType) {
      case 'CUSTOMERS':
        return this.data.users.filter(u => u.role === 'CUSTOMER').map(c => ({
          'Customer ID': c.id,
          'Name': c.name,
          'Mobile': c.mobile,
          'Email': c.email,
          'Aadhaar KYC': c.aadhaarVerified ? 'Verified' : 'Pending',
          'Status': c.status || 'Active',
          'Registered On': c.createdAt || '2026-05-10'
        }));

      case 'OWNERS':
        return this.data.users.filter(u => u.role === 'OWNER').map(o => {
          const props = this.data.properties.filter(p => p.ownerId === o.id).length;
          return {
            'Owner ID': o.id,
            'Name': o.name,
            'Mobile': o.mobile,
            'Email': o.email,
            'Properties Listed': props,
            'Contact Privacy': o.contactSettings || 'CALL_MSG_ON',
            'Status': o.status || 'Active'
          };
        });

      case 'PROPERTIES':
        return this.data.properties.map(p => ({
          'Property ID': p.id,
          'Title': p.title,
          'City': p.city,
          'Locality': p.locality,
          'Area Type': p.areaType,
          'Property Type': p.propertyType,
          'Total Units': p.rooms.length,
          'Available Units': p.rooms.filter(r => r.status === 'Available').length,
          'Rented Units': p.rooms.filter(r => r.status === 'Rented').length,
          'Approval Status': p.approvalStatus || 'Approved'
        }));

      case 'RENT_COLLECTION':
      case 'PAYMENTS':
        return this.data.rentPayments.map(p => {
          const cust = this.data.users.find(u => u.id === p.customerId);
          const owner = this.data.users.find(u => u.id === p.ownerId);
          return {
            'Receipt #': p.receiptNumber || 'N/A',
            'Rent Month': p.rentMonth,
            'Tenant': cust ? cust.name : p.customerId,
            'Owner': owner ? owner.name : p.ownerId,
            'Amount (₹)': p.rentAmount,
            'Due Date': p.dueDate,
            'Payment Date': p.paymentDate || 'Pending',
            'Mode': p.paymentMode || 'N/A',
            'Status': p.paymentStatus,
            'Transaction Ref': p.transactionRef || 'N/A'
          };
        });

      case 'COMPLAINTS':
        return this.data.complaints.map(c => ({
          'Complaint ID': c.id,
          'Subject': c.subject,
          'Category': c.category,
          'User': c.userName,
          'User Role': c.userRole,
          'Status': c.status,
          'Admin Response': c.adminResponse || 'None',
          'Date': c.createdAt || '2026-09-20'
        }));

      case 'AGREEMENTS':
        return this.data.agreements.map(a => {
          const cust = this.data.users.find(u => u.id === a.customerId);
          return {
            'Agreement ID': a.id,
            'Customer': cust ? cust.name : a.customerId,
            'Monthly Rent (₹)': a.monthlyRent,
            'Security Deposit (₹)': a.securityDeposit,
            'Due Day': a.dueDayOfMonth,
            'Signed Date': a.verificationDate,
            'Status': a.status
          };
        });

      default:
        return [];
    }
  }

  adminExportReportCSV(reportType) {
    const records = this.adminGenerateReport(reportType);
    if (!records || records.length === 0) return '';
    const headers = Object.keys(records[0]);
    const csvRows = [headers.join(',')];

    records.forEach(row => {
      const values = headers.map(h => {
        const escaped = ('' + (row[h] || '')).replace(/"/g, '""');
        return `"${escaped}"`;
      });
      csvRows.push(values.join(','));
    });

    return csvRows.join('\n');
  }

  // --- Admin User Management (RBAC) (Section 22) ---

  adminAddAdminUser({ name, email, mobile, role, permissions }) {
    const id = 'admin_' + Date.now();
    const newUser = {
      id,
      name,
      email,
      mobile,
      role: 'ADMIN',
      adminRole: role || 'Admin',
      status: 'Active',
      permissions: permissions || ['ALL'],
      lastLogin: 'Never'
    };

    if (!this.data.adminUsers) this.data.adminUsers = [];
    this.data.adminUsers.push(newUser);

    this.addAuditLog({
      action: 'ADMIN_USER_CREATED',
      module: 'Admin Users',
      recordId: id,
      oldValue: '',
      newValue: `${name} (${role})`
    });

    this.notifyListeners('ADMIN_USERS_UPDATED');
    return newUser;
  }

  adminToggleAdminUserStatus(adminId) {
    const admin = this.data.adminUsers.find(a => a.id === adminId);
    if (admin) {
      const oldVal = admin.status;
      admin.status = admin.status === 'Active' ? 'Deactivated' : 'Active';

      this.addAuditLog({
        action: 'ADMIN_USER_STATUS_TOGGLED',
        module: 'Admin Users',
        recordId: adminId,
        oldValue: oldVal,
        newValue: admin.status
      });

      this.notifyListeners('ADMIN_USERS_UPDATED');
    }
  }

  // --- Global Admin Search (Section 24) ---

  adminGlobalSearch(query) {
    if (!query || query.trim() === '') return null;
    const q = query.toLowerCase().trim();

    const customers = this.data.users.filter(u => u.role === 'CUSTOMER' && (u.name.toLowerCase().includes(q) || u.mobile.includes(q) || u.email.toLowerCase().includes(q)));
    const owners = this.data.users.filter(u => u.role === 'OWNER' && (u.name.toLowerCase().includes(q) || u.mobile.includes(q) || u.email.toLowerCase().includes(q)));
    const properties = this.data.properties.filter(p => p.title.toLowerCase().includes(q) || p.locality.toLowerCase().includes(q) || p.city.toLowerCase().includes(q) || p.id.toLowerCase().includes(q));
    const payments = this.data.rentPayments.filter(p => (p.receiptNumber && p.receiptNumber.toLowerCase().includes(q)) || (p.transactionRef && p.transactionRef.toLowerCase().includes(q)) || p.rentMonth.toLowerCase().includes(q));
    const complaints = this.data.complaints.filter(c => c.subject.toLowerCase().includes(q) || c.userName.toLowerCase().includes(q) || c.id.toLowerCase().includes(q));
    const agreements = this.data.agreements.filter(a => a.id.toLowerCase().includes(q));
    const requests = this.data.rentalRequests.filter(r => r.id.toLowerCase().includes(q));

    return { customers, owners, properties, payments, complaints, agreements, requests };
  }

  // --- Admin Settings Update (Section 25) ---

  adminUpdateSettings(newSettings) {
    this.data.settings = { ...this.data.settings, ...newSettings };
    this.addAuditLog({
      action: 'SETTINGS_UPDATED',
      module: 'Settings',
      recordId: 'platform_config',
      oldValue: 'Previous Config',
      newValue: 'Updated Config'
    });
    this.notifyListeners('SETTINGS_UPDATED');
  }
}

// Global Singleton
if (typeof window !== 'undefined') {
  window.AppState = AppState;
  window.appState = new AppState();
}
if (typeof module !== 'undefined' && module.exports) {
  module.exports = { AppState };
}


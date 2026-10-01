/**
 * Monthly Home, Room, Apartment & Property Rental Platform
 * Customer App View Controller & Interactions
 */

class CustomerAppController {
  constructor(appState) {
    this.state = appState;
    this.currentTab = 'home'; // 'home' | 'search' | 'saved' | 'rentals' | 'profile'
  }

  render(container) {
    container.innerHTML = `
      <!-- Customer App Container -->
      <div class="customer-app-root">
        <!-- Dynamic Main Content Based on Active Tab -->
        <div id="customer-tab-content">
          ${this.getTabContentHTML()}
        </div>

        <!-- Mobile Bottom Navigation Bar (Customer) -->
        <nav class="bottom-nav-bar" id="customer-bottom-nav">
          <button class="nav-item-btn ${this.currentTab === 'home' ? 'active' : ''}" onclick="window.customerApp.switchTab('home')">
            <span class="nav-icon">🏠</span>
            <span>Home</span>
          </button>
          <button class="nav-item-btn ${this.currentTab === 'search' ? 'active' : ''}" onclick="window.customerApp.switchTab('search')">
            <span class="nav-icon">🔍</span>
            <span>Search</span>
          </button>
          <button class="nav-item-btn ${this.currentTab === 'saved' ? 'active' : ''}" onclick="window.customerApp.switchTab('saved')">
            <span class="nav-icon">❤️</span>
            <span>Saved</span>
          </button>
          <button class="nav-item-btn ${this.currentTab === 'rentals' ? 'active' : ''}" onclick="window.customerApp.switchTab('rentals')">
            <span class="nav-icon">📑</span>
            <span>Rentals</span>
          </button>
          <button class="nav-item-btn ${this.currentTab === 'profile' ? 'active' : ''}" onclick="window.customerApp.switchTab('profile')">
            <span class="nav-icon">👤</span>
            <span>Profile</span>
          </button>
        </nav>
      </div>
    `;

    this.attachEventListeners();
  }

  switchTab(tabName) {
    this.currentTab = tabName;
    const contentEl = document.getElementById('customer-tab-content');
    if (contentEl) {
      contentEl.innerHTML = this.getTabContentHTML();
      this.attachEventListeners();
    }
    // Update bottom nav buttons
    const navBtns = document.querySelectorAll('#customer-bottom-nav .nav-item-btn');
    navBtns.forEach(btn => btn.classList.remove('active'));
    const activeBtn = Array.from(navBtns).find(btn => btn.textContent.toLowerCase().includes(tabName));
    if (activeBtn) activeBtn.classList.add('active');
  }

  getTabContentHTML() {
    switch (this.currentTab) {
      case 'home':
        return this.renderHomeTab();
      case 'search':
        return this.renderSearchTab();
      case 'saved':
        return this.renderSavedTab();
      case 'rentals':
        return this.renderRentalsTab();
      case 'profile':
        return this.renderProfileTab();
      default:
        return this.renderHomeTab();
    }
  }

  // ===================================================================
  // 1. HOME TAB (Sections 2, 3, 4, 5, 6, 33, 34)
  // ===================================================================
  renderHomeTab() {
    const user = this.state.getCurrentUser();
    const f = this.state.searchFilters;
    const searchResults = this.state.getSearchResults();

    // Prepare urban & rural location options
    const isUrban = f.areaType !== 'rural';
    const cityOptions = isUrban
      ? this.state.data.areas.urban.map(c => `<option value="${c.city}" ${f.city === c.city ? 'selected' : ''}>${c.city}</option>`).join('')
      : this.state.data.areas.rural.map(r => `<option value="${r.district}" ${f.city === r.district ? 'selected' : ''}>${r.district}</option>`).join('') || '';

    let localityOptions = '<option value="">All Areas / Localities</option>';
    if (f.city) {
      if (isUrban) {
        const found = this.state.data.areas.urban.find(c => c.city.toLowerCase() === f.city.toLowerCase());
        if (found) {
          localityOptions += found.localities.map(l => `<option value="${l}" ${f.locality === l ? 'selected' : ''}>${l}</option>`).join('');
        }
      } else {
        const found = this.state.data.areas.rural.find(r => r.district.toLowerCase() === f.city.toLowerCase());
        if (found) {
          localityOptions += found.villages.map(v => `<option value="${v}" ${f.locality === v ? 'selected' : ''}>${v}</option>`).join('');
        }
      }
    }

    return `
      <!-- Customer Hero Header -->
      <div class="customer-hero-header">
        <div class="hero-welcome-row">
          <div class="user-greeting">
            <h2>Namaste, ${user.name.split(' ')[0]} 👋</h2>
            <p>Find your ideal monthly rental home, room or PG</p>
          </div>
          <div class="hero-stats-pill">
            <span>🛡️ Verified Properties</span>
          </div>
        </div>

        <!-- Location Selection Card (Urban / Rural & Hierarchy) -->
        <div class="location-selector-card">
          <div class="urban-rural-segmented">
            <button class="segmented-btn ${f.areaType === 'all' ? 'active' : ''}" onclick="window.customerApp.setAreaType('all')">All Locations</button>
            <button class="segmented-btn ${f.areaType === 'urban' ? 'active' : ''}" onclick="window.customerApp.setAreaType('urban')">🌆 Urban Cities</button>
            <button class="segmented-btn ${f.areaType === 'rural' ? 'active' : ''}" onclick="window.customerApp.setAreaType('rural')">🌾 Rural & Villages</button>
          </div>

          <div class="location-dropdowns-row">
            <div class="select-wrapper">
              <select id="cust-city-select" onchange="window.customerApp.onCityChange(this.value)">
                <option value="">${f.areaType === 'rural' ? 'All Rural Districts' : 'All Cities'}</option>
                ${cityOptions}
              </select>
            </div>
            <div class="select-wrapper">
              <select id="cust-locality-select" onchange="window.customerApp.onLocalityChange(this.value)">
                ${localityOptions}
              </select>
            </div>
          </div>

          <!-- Search Input -->
          <div class="search-input-box">
            <span class="search-icon-left">🔍</span>
            <input 
              type="text" 
              placeholder="Search city, area, village, or property..." 
              value="${f.searchQuery || ''}"
              oninput="window.customerApp.onSearchQueryChange(this.value)"
            />
            <button class="filter-btn-right" onclick="window.customerApp.switchTab('search')" title="Open Filters">
              ⚙️
            </button>
          </div>
        </div>
      </div>

      <!-- Property Type Horizontal Shortcuts (Section 4 & 33) -->
      <div class="section-horizontal-scroll">
        <div class="section-header-title">
          <h3>Property Type</h3>
          <span class="badge-counter">${this.state.data.propertyTypes.length} Types</span>
        </div>
        <div class="type-shortcuts-tray">
          <div class="type-chip ${!f.propertyType ? 'active' : ''}" onclick="window.customerApp.setPropertyType('')">
            <span class="type-icon">🌟</span>
            <span class="type-name">All Types</span>
          </div>
          ${this.state.data.propertyTypes.map(t => `
            <div class="type-chip ${f.propertyType === t.id ? 'active' : ''}" onclick="window.customerApp.setPropertyType('${t.id}')">
              <span class="type-icon">${t.icon}</span>
              <span class="type-name">${t.name}</span>
            </div>
          `).join('')}
        </div>
      </div>

      <!-- Mandatory "Suitable For" Filter Bar (Section 5 & 16) -->
      <div class="suitable-filter-box">
        <div class="section-header-title">
          <h3>Suitable For / Customer Type <span style="color:var(--accent); font-size:0.75rem;">(Match Eligibility)</span></h3>
          ${f.suitableFor.length > 0 ? `<a href="javascript:void(0)" onclick="window.customerApp.clearSuitableFilter()">Clear (${f.suitableFor.length})</a>` : ''}
        </div>
        <div class="suitable-tag-pills">
          ${this.state.data.customerTypes.map(ct => {
            const isSelected = f.suitableFor.includes(ct.id);
            return `
              <button 
                class="suitable-pill ${isSelected ? 'active' : ''}" 
                onclick="window.customerApp.toggleSuitableType('${ct.id}')"
              >
                ${isSelected ? '✓ ' : '+ '}${ct.name}
              </button>
            `;
          }).join('')}
        </div>
      </div>

      <!-- Available Properties Feed (Section 7, 33, 34) -->
      <div class="properties-feed-container">
        <div class="section-header-title" style="margin-bottom: 4px;">
          <h3>Available Rentals</h3>
          <span style="font-size:0.78rem; color:var(--text-muted);">
            Showing ${searchResults.length} verified monthly listings
          </span>
        </div>

        ${searchResults.length === 0 ? `
          <div style="text-align:center; padding: 40px 20px; background:#fff; border-radius:16px; border:1px solid #e2e8f0;">
            <div style="font-size: 3rem; margin-bottom:10px;">🏘️</div>
            <h4 style="font-size:1.1rem; margin-bottom:6px;">No available properties match your filters</h4>
            <p style="font-size:0.8rem; color:#64748b; margin-bottom:16px;">Try adjusting your location, rent budget, or suitable customer type.</p>
            <button class="btn-primary-sm" onclick="window.customerApp.resetAllFilters()">Reset All Filters</button>
          </div>
        ` : searchResults.map(item => this.renderPropertyCard(item)).join('')}
      </div>
    `;
  }

  // ===================================================================
  // PROPERTY CARD RENDERER (Section 8, 34)
  // ===================================================================
  renderPropertyCard({ property, room, owner, matchedSuitableTypes }) {
    const isSaved = this.state.isPropertySaved(`${property.id}_${room.id}`);
    const isRented = room.status === 'Rented';

    // Suitable types names
    const suitableNames = room.suitableFor.map(sId => {
      const found = this.state.data.customerTypes.find(c => c.id === sId);
      return found ? found.name : sId;
    });

    const galleryList = (property.gallery && property.gallery.length > 0)
      ? property.gallery
      : ((property.images && property.images.length > 0) ? property.images : [room.featuredImage || property.image]);

    return `
      <div class="property-rental-card" data-prop-id="${property.id}" data-room-id="${room.id}">
        <!-- Image & Badges -->
        <div class="card-image-wrap" onclick="window.customerApp.openPropertyDetails('${property.id}', '${room.id}')" style="cursor:pointer;">
          <img src="${galleryList[0]}" alt="${property.title}" loading="lazy" />
          <div class="card-badges-row">
            <span class="badge-status ${isRented ? 'rented' : (room.status === 'Available' ? 'available' : 'pending')}">
              ${room.status}
            </span>
            <span class="badge-area-type">
              ${property.areaType === 'rural' ? '🌾 Rural' : '🌆 Urban'} • ${property.city}
            </span>
          </div>
          ${galleryList.length > 1 ? `
            <div style="position:absolute; bottom:8px; right:8px; background:rgba(0,0,0,0.75); color:#fff; padding:3px 8px; border-radius:12px; font-size:0.7rem; font-weight:700; display:flex; align-items:center; gap:4px; z-index:2;">
              <span>📷</span> ${galleryList.length} Photos
            </div>
          ` : ''}
          <button 
            class="card-bookmark-btn ${isSaved ? 'saved' : ''}" 
            onclick="event.stopPropagation(); window.customerApp.toggleSave('${property.id}_${room.id}')"
            title="${isSaved ? 'Remove from Saved' : 'Save Property'}"
          >
            ${isSaved ? '❤️' : '🤍'}
          </button>
        </div>

        <!-- Card Body Content -->
        <div class="card-content-body">
          <div class="card-location-row">
            <span>📍 ${property.locality}, ${property.city}</span>
            <span>•</span>
            <span>⭐ ${property.rating} (${property.reviewsCount || 10})</span>
          </div>

          <h4 class="card-title" onclick="window.customerApp.openPropertyDetails('${property.id}', '${room.id}')" style="cursor:pointer;">
            ${property.title}
          </h4>

          <div style="display:flex; gap:6px; flex-wrap:wrap; margin-bottom:6px;">
            <span class="card-room-badge">🛏️ ${room.roomNumber} (${room.roomType.toUpperCase()})</span>
            <span class="card-room-badge">📐 ${room.sizeSqFt}</span>
            <span class="card-room-badge">🛋️ ${room.furnishing.split('(')[0].trim()}</span>
          </div>

          <!-- Suitable For Highlights -->
          <div class="card-suitable-banner">
            <div class="suitable-label">✓ Suitable For:</div>
            <div class="suitable-tags">
              ${suitableNames.slice(0, 3).join(' • ')}${suitableNames.length > 3 ? ` +${suitableNames.length - 3} more` : ''}
            </div>
          </div>

          <!-- Pricing & Action Footer -->
          <div class="card-footer-pricing">
            <div class="price-box">
              <span class="price-amount">₹${room.monthlyRent.toLocaleString('en-IN')}</span>
              <span class="price-period">/ month</span>
              <div class="deposit-hint">Deposit: ₹${room.securityDeposit.toLocaleString('en-IN')}</div>
            </div>

            <div class="card-actions-group">
              <button class="btn-primary-sm" onclick="window.customerApp.openPropertyDetails('${property.id}', '${room.id}')">
                View Details
              </button>
            </div>
          </div>
        </div>
      </div>
    `;
  }

  // ===================================================================
  // 2. SEARCH & FILTER TAB (Section 6)
  // ===================================================================
  renderSearchTab() {
    const f = this.state.searchFilters;

    return `
      <div style="padding: 20px 18px 30px;">
        <div class="section-header-title">
          <h2>🔍 Advanced Rental Filters</h2>
          <a href="javascript:void(0)" onclick="window.customerApp.resetAllFilters()">Reset All</a>
        </div>

        <div style="background:#fff; border-radius:16px; padding:18px; border:1px solid #e2e8f0; margin-top:12px;">
          <!-- Monthly Rent Budget Slider -->
          <div class="form-group">
            <div style="display:flex; justify-content:space-between; margin-bottom:6px;">
              <label style="font-size:0.85rem;">Max Monthly Budget</label>
              <span style="font-weight:800; color:var(--primary); font-size:1rem;">₹${f.maxRent.toLocaleString('en-IN')}</span>
            </div>
            <input 
              type="range" 
              min="3000" 
              max="60000" 
              step="1000" 
              value="${f.maxRent}" 
              style="width:100%; accent-color:var(--primary);"
              oninput="window.customerApp.onRentRangeChange(this.value)"
            />
            <div style="display:flex; justify-content:space-between; font-size:0.7rem; color:#94a3b8; margin-top:2px;">
              <span>₹3,000</span>
              <span>₹30,000</span>
              <span>₹60,000+</span>
            </div>
          </div>

          <!-- Area Type -->
          <div class="form-group">
            <label>Location Category</label>
            <select class="form-control" onchange="window.customerApp.setAreaType(this.value)">
              <option value="all" ${f.areaType === 'all' ? 'selected' : ''}>All Locations (Urban & Rural)</option>
              <option value="urban" ${f.areaType === 'urban' ? 'selected' : ''}>Urban Cities Only</option>
              <option value="rural" ${f.areaType === 'rural' ? 'selected' : ''}>Rural Villages & Townships</option>
            </select>
          </div>

          <!-- Property Type -->
          <div class="form-group">
            <label>Property / Accommodation Type</label>
            <select class="form-control" onchange="window.customerApp.setPropertyType(this.value)">
              <option value="">All Property Types</option>
              ${this.state.data.propertyTypes.map(pt => `<option value="${pt.id}" ${f.propertyType === pt.id ? 'selected' : ''}>${pt.icon} ${pt.name}</option>`).join('')}
            </select>
          </div>

          <!-- Furnishing Type -->
          <div class="form-group">
            <label>Furnishing Status</label>
            <select class="form-control" onchange="window.customerApp.setFurnishing(this.value)">
              <option value="all" ${f.furnishing === 'all' ? 'selected' : ''}>Any Furnishing</option>
              <option value="furnished" ${f.furnishing === 'furnished' ? 'selected' : ''}>Fully Furnished</option>
              <option value="semi" ${f.furnishing === 'semi' ? 'selected' : ''}>Semi-Furnished</option>
              <option value="unfurnished" ${f.furnishing === 'unfurnished' ? 'selected' : ''}>Unfurnished</option>
            </select>
          </div>

          <!-- Suitable For Selection in Search -->
          <div class="form-group">
            <label>Suitable For (Match at least one)</label>
            <div class="suitable-tag-pills">
              ${this.state.data.customerTypes.map(ct => {
                const isSelected = f.suitableFor.includes(ct.id);
                return `
                  <button 
                    class="suitable-pill ${isSelected ? 'active' : ''}" 
                    onclick="window.customerApp.toggleSuitableType('${ct.id}')"
                  >
                    ${isSelected ? '✓ ' : '+ '}${ct.name}
                  </button>
                `;
              }).join('')}
            </div>
          </div>

          <!-- Only Available Switch -->
          <div style="display:flex; justify-content:space-between; align-items:center; padding:12px 0; border-top:1px solid #f1f5f9; margin-top:12px;">
            <div>
              <div style="font-weight:700; font-size:0.85rem; color:#1e293b;">Show Only Available Properties</div>
              <div style="font-size:0.72rem; color:#64748b;">Hide rented, reserved or unavailable properties</div>
            </div>
            <input 
              type="checkbox" 
              ${f.onlyAvailable ? 'checked' : ''} 
              style="width:18px; height:18px; accent-color:var(--primary); cursor:pointer;"
              onchange="window.customerApp.toggleOnlyAvailable(this.checked)"
            />
          </div>

          <button class="btn-primary-sm" style="width:100%; padding:12px; margin-top:16px; font-size:0.9rem;" onclick="window.customerApp.switchTab('home')">
            Apply Filters & View Results
          </button>
        </div>
      </div>
    `;
  }

  // ===================================================================
  // 3. SAVED / WISHLIST TAB
  // ===================================================================
  renderSavedTab() {
    const savedIds = this.state.data.savedProperties;
    const savedItems = [];

    for (const savedKey of savedIds) {
      const [propId, roomId] = savedKey.split('_');
      const details = this.state.getPropertyRoomById(propId, roomId);
      if (details) {
        savedItems.push(details);
      }
    }

    return `
      <div style="padding: 20px 18px 30px;">
        <div class="section-header-title">
          <h2>❤️ Saved Properties</h2>
          <span class="badge-counter">${savedItems.length} Saved</span>
        </div>

        ${savedItems.length === 0 ? `
          <div style="text-align:center; padding: 50px 20px; background:#fff; border-radius:16px; border:1px solid #e2e8f0; margin-top:16px;">
            <div style="font-size: 3rem; margin-bottom:10px;">🤍</div>
            <h4>No saved properties yet</h4>
            <p style="font-size:0.8rem; color:#64748b; margin-top:4px;">Tap the heart icon on any property card to bookmark it for later.</p>
            <button class="btn-primary-sm" style="margin-top:16px;" onclick="window.customerApp.switchTab('home')">Explore Properties</button>
          </div>
        ` : `
          <div class="properties-feed-container" style="padding:16px 0 0 0;">
            ${savedItems.map(item => this.renderPropertyCard(item)).join('')}
          </div>
        `}
      </div>
    `;
  }

  // ===================================================================
  // 4. CUSTOMER RENTALS & MONTHLY RENT DASHBOARD (Sections 10, 12, 13, 20, 21)
  // ===================================================================
  renderRentalsTab() {
    const user = this.state.getCurrentUser();
    
    // Find active rentals for this customer
    const myActiveRentals = this.state.data.activeRentals.filter(r => r.customerId === user.id && r.status === 'Active');
    
    // Find rental requests sent by this customer
    const myRequests = this.state.data.rentalRequests.filter(r => r.customerId === user.id);

    // Payments for this customer
    const myPayments = this.state.data.rentPayments.filter(p => p.customerId === user.id);

    return `
      <div class="rent-dashboard-container">
        <div class="section-header-title" style="margin-bottom:0;">
          <h2>📑 My Rentals & Monthly Rent</h2>
          <span style="font-size:0.75rem; color:var(--text-muted);">Live Rent Ledger</span>
        </div>

        <!-- Section A: Active Rental Hero Dashboard (Section 21) -->
        ${myActiveRentals.length > 0 ? myActiveRentals.map(rental => {
          const propDetails = this.state.getPropertyRoomById(rental.propertyId, rental.roomId);
          const pendingPay = myPayments.find(p => p.rentalId === rental.id && p.paymentStatus === 'Pending');
          const totalPaid = myPayments.filter(p => p.rentalId === rental.id && p.paymentStatus === 'Paid')
                                      .reduce((sum, p) => sum + p.rentAmount, 0);

          return `
            <div class="active-rental-hero-card">
              <div class="hero-property-top">
                <div>
                  <span style="background:rgba(16,185,129,0.25); color:#34d399; font-size:0.68rem; font-weight:800; padding:2px 8px; border-radius:999px; text-transform:uppercase;">
                    ● Active Monthly Rental
                  </span>
                  <h3 style="margin-top:6px;">${rental.propertySnapshot.title}</h3>
                  <p>📍 ${rental.propertySnapshot.roomNumber} • ${rental.propertySnapshot.address}</p>
                </div>
                <div class="hero-due-badge ${pendingPay ? 'pending' : 'paid'}">
                  ${pendingPay ? `Due: ${rental.monthlyDueDay}th of this month` : `✓ Rent Paid for Current Month`}
                </div>
              </div>

              <!-- Rent Key Stats Grid -->
              <div class="hero-rent-stats-grid">
                <div class="rent-stat-item">
                  <span class="stat-label">Monthly Rent</span>
                  <span class="stat-val">₹${rental.monthlyRent.toLocaleString('en-IN')}</span>
                </div>
                <div class="rent-stat-item">
                  <span class="stat-label">Security Deposit</span>
                  <span class="stat-val">₹${rental.securityDeposit.toLocaleString('en-IN')}</span>
                </div>
                <div class="rent-stat-item">
                  <span class="stat-label">Total Paid to Date</span>
                  <span class="stat-val">₹${totalPaid.toLocaleString('en-IN')}</span>
                </div>
              </div>

              <!-- Action CTAs: Pay Rent, Record Cash, Contact Owner -->
              <div class="hero-action-btns-row">
                ${pendingPay ? `
                  <button class="btn-pay-rent" onclick="window.customerApp.openPayRentModal('${pendingPay.id}')">
                    💳 Pay Rent Now (₹${rental.monthlyRent.toLocaleString('en-IN')})
                  </button>
                  <button class="btn-record-cash" onclick="window.customerApp.openCashRecordModal('${pendingPay.id}')">
                    💵 Paid via Cash
                  </button>
                ` : `
                  <button class="btn-pay-rent" style="background:#059669;" disabled>
                    ✓ All Dues Cleared for this Month
                  </button>
                `}
              </div>
            </div>
          `;
        }).join('') : `
          <div style="background:#ffffff; border-radius:16px; padding:24px 18px; border:1px solid #e2e8f0; text-align:center;">
            <div style="font-size:2.5rem; margin-bottom:8px;">🏠</div>
            <h4 style="font-size:1rem; margin-bottom:4px;">No Active Rental Agreement Yet</h4>
            <p style="font-size:0.78rem; color:#64748b; margin-bottom:14px;">Once your rental request is accepted and agreement verified, your monthly rent dashboard and reminders will appear here.</p>
            <button class="btn-primary-sm" onclick="window.customerApp.switchTab('home')">Search Properties to Rent</button>
          </div>
        `}

        <!-- Section B: Rental Requests & Agreement Progress Tracker (Section 10, 11, 12, 13, 35) -->
        ${myRequests.length > 0 ? `
          <div style="background:#ffffff; border-radius:16px; padding:16px; border:1px solid #e2e8f0;">
            <div class="section-header-title">
              <h3>Rental Requests & Agreements</h3>
              <span class="badge-counter">${myRequests.length} Requests</span>
            </div>

            <div style="display:flex; flex-direction:column; gap:12px; margin-top:10px;">
              ${myRequests.map(req => {
                const propDetails = this.state.getPropertyRoomById(req.propertyId, req.roomId);
                const propTitle = propDetails ? propDetails.property.title : 'Property';
                const roomNo = propDetails ? propDetails.room.roomNumber : 'Room';
                const rentAmt = propDetails ? propDetails.room.monthlyRent : 0;

                return `
                  <div style="border:1px solid #e2e8f0; border-radius:12px; padding:12px; background:#f8fafc;">
                    <div style="display:flex; justify-content:space-between; align-items:flex-start;">
                      <div>
                        <h4 style="font-size:0.95rem; color:#0f172a;">${propTitle} (${roomNo})</h4>
                        <p style="font-size:0.75rem; color:#64748b;">Expected Move-in: <strong>${req.expectedMoveInDate}</strong> • Period: <strong>${req.rentalPeriodMonths} Months</strong></p>
                      </div>
                      <span class="badge-status ${req.status === 'Accepted' ? 'available' : (req.status === 'Rejected' ? 'rented' : 'pending')}">
                        ${req.status}
                      </span>
                    </div>

                    <!-- Progress Step Indicator (Section 35) -->
                    <div style="display:flex; align-items:center; gap:4px; margin:12px 0 8px; font-size:0.68rem; font-weight:700;">
                      <span style="color:#059669;">1. Request Sent ✓</span>
                      <span>→</span>
                      <span style="color:${req.status === 'Accepted' ? '#059669' : '#94a3b8'};">2. Owner Approved ${req.status === 'Accepted' ? '✓' : ''}</span>
                      <span>→</span>
                      <span style="color:${req.termsConfirmedByCustomer ? '#059669' : '#94a3b8'};">3. Terms Confirmed ${req.termsConfirmedByCustomer ? '✓' : ''}</span>
                      <span>→</span>
                      <span style="color:${user.aadhaarVerified ? '#059669' : '#94a3b8'};">4. Aadhaar KYC & Agreement</span>
                    </div>

                    <!-- Action buttons based on request state -->
                    ${req.status === 'Accepted' && (!req.termsConfirmedByCustomer || !user.aadhaarVerified) ? `
                      <div style="background:#ecfdf5; border:1px solid #a7f3d0; border-radius:8px; padding:10px; margin-top:8px;">
                        <p style="font-size:0.78rem; color:#065f46; font-weight:600;">🎉 Owner accepted your request! Please review final terms and complete Aadhaar e-KYC.</p>
                        <button class="btn-primary-sm" style="margin-top:8px; width:100%;" onclick="window.customerApp.openAgreementSigningModal('${req.id}')">
                          Proceed to Terms & Aadhaar KYC Agreement
                        </button>
                      </div>
                    ` : ''}
                  </div>
                `;
              }).join('')}
            </div>
          </div>
        ` : ''}

        <!-- Section C: Month-Wise Rent Payment History Timeline (Section 20) -->
        <div class="rent-history-section">
          <div class="section-header-title">
            <h3>Month-Wise Rent History</h3>
            <span style="font-size:0.75rem; color:#64748b;">${myPayments.length} Monthly Records</span>
          </div>

          <div class="history-timeline-list">
            ${myPayments.length === 0 ? `
              <p style="font-size:0.8rem; color:#94a3b8; text-align:center; padding:16px 0;">No rent payment records generated yet.</p>
            ` : myPayments.map(pay => `
              <div class="history-item-card">
                <div class="history-left-info">
                  <div class="hist-month">${pay.rentMonth}</div>
                  <div class="hist-details">
                    ${pay.paymentStatus === 'Paid' ? `
                      <span>Paid on ${pay.paymentDate} via <strong>${pay.paymentMode}</strong></span>
                      <div style="color:#64748b; font-size:0.68rem;">Ref: ${pay.transactionRef || 'N/A'}</div>
                    ` : `
                      <span style="color:#d97706; font-weight:600;">Due on ${pay.dueDate}</span>
                    `}
                  </div>
                </div>

                <div class="history-right-action">
                  <div class="hist-amount">₹${pay.rentAmount.toLocaleString('en-IN')}</div>
                  <span class="hist-status-pill ${pay.paymentStatus.toLowerCase()}">${pay.paymentStatus}</span>
                  
                  ${pay.paymentStatus === 'Paid' ? `
                    <div>
                      <button class="btn-receipt-download" onclick="window.appCoordinator.openDigitalReceipt('${pay.id}')">
                        📄 Receipt
                      </button>
                    </div>
                  ` : `
                    <div>
                      <button class="btn-receipt-download" style="color:#d97706; border-color:#fde68a;" onclick="window.customerApp.openPayRentModal('${pay.id}')">
                        Pay Now
                      </button>
                    </div>
                  `}
                </div>
              </div>
            `).join('')}
          </div>
        </div>
      </div>
    `;
  }

  // ===================================================================
  // 5. PROFILE & COMPLAINTS TAB (Sections 1, 26)
  // ===================================================================
  renderProfileTab() {
    const user = this.state.getCurrentUser();
    const myComplaints = this.state.data.complaints.filter(c => c.userId === user.id);
    const myNotifs = this.state.getNotificationsForUser(user.id);

    return `
      <div style="padding: 20px 18px 30px;">
        <!-- Profile Header Card -->
        <div style="background:#fff; border-radius:16px; padding:18px; border:1px solid #e2e8f0; display:flex; align-items:center; gap:16px; margin-bottom:16px;">
          <div style="width:56px; height:56px; border-radius:50%; background:#e0f2fe; display:flex; align-items:center; justify-content:center; font-size:2rem;">
            ${user.avatar || '👨‍💼'}
          </div>
          <div>
            <h3 style="font-size:1.15rem; margin-bottom:2px;">${user.name}</h3>
            <p style="font-size:0.8rem; color:#64748b;">📱 +91 ${user.mobile} • ${user.email}</p>
            <div style="display:flex; gap:6px; margin-top:6px;">
              <span style="background:${user.aadhaarVerified ? '#d1fae5' : '#fee2e2'}; color:${user.aadhaarVerified ? '#065f46' : '#991b1b'}; font-size:0.7rem; font-weight:700; padding:2px 8px; border-radius:999px;">
                ${user.aadhaarVerified ? `✓ Aadhaar Verified (•••• ${user.aadhaarLast4 || '4512'})` : '⚠️ Aadhaar KYC Pending'}
              </span>
            </div>
          </div>
        </div>

        <!-- Quick Aadhaar KYC Button if not verified -->
        ${!user.aadhaarVerified ? `
          <div style="background:#fffbeb; border:1px solid #fcd34d; border-radius:14px; padding:14px; margin-bottom:16px;">
            <h4 style="font-size:0.92rem; color:#92400e; margin-bottom:4px;">Aadhaar Identity Verification Required</h4>
            <p style="font-size:0.78rem; color:#78350f; margin-bottom:10px;">Complete paperless e-KYC before signing rental agreements with property owners.</p>
            <button class="btn-primary-sm" style="background:#d97706;" onclick="window.customerApp.openAadhaarKYCModal()">
              Verify Aadhaar e-KYC Now
            </button>
          </div>
        ` : ''}

        <!-- In-App Notifications Center (Section 24 & 26) -->
        <div style="background:#fff; border-radius:16px; padding:16px; border:1px solid #e2e8f0; margin-bottom:16px;">
          <div class="section-header-title">
            <h3>🔔 In-App Rent Reminders & Alerts</h3>
            <span class="badge-counter">${myNotifs.length} Alerts</span>
          </div>
          <div style="display:flex; flex-direction:column; gap:8px; margin-top:10px;">
            ${myNotifs.length === 0 ? `
              <p style="font-size:0.8rem; color:#94a3b8; text-align:center; padding:10px 0;">No active notifications.</p>
            ` : myNotifs.map(n => `
              <div style="background:#f8fafc; border-radius:10px; padding:10px 12px; border-left:3px solid ${n.type.includes('REMINDER') ? '#f59e0b' : '#0f766e'};">
                <div style="display:flex; justify-content:space-between; font-size:0.72rem; color:#64748b;">
                  <strong>${n.title}</strong>
                  <span>${new Date(n.createdAt).toLocaleDateString()}</span>
                </div>
                <div style="font-size:0.78rem; color:#1e293b; margin-top:2px;">${n.message}</div>
              </div>
            `).join('')}
          </div>
        </div>

        <!-- Complaints & Maintenance Support (Section 26 & 28) -->
        <div style="background:#fff; border-radius:16px; padding:16px; border:1px solid #e2e8f0;">
          <div class="section-header-title">
            <h3>🛠️ Maintenance & Support Tickets</h3>
            <button class="btn-primary-sm" style="font-size:0.72rem; padding:4px 10px;" onclick="window.customerApp.openNewComplaintModal()">
              + Raise Ticket
            </button>
          </div>

          <div style="display:flex; flex-direction:column; gap:10px; margin-top:10px;">
            ${myComplaints.length === 0 ? `
              <p style="font-size:0.8rem; color:#94a3b8; text-align:center; padding:12px 0;">No maintenance complaints filed.</p>
            ` : myComplaints.map(comp => `
              <div style="background:#f8fafc; border-radius:10px; padding:12px; border:1px solid #e2e8f0;">
                <div style="display:flex; justify-content:space-between; align-items:flex-start;">
                  <div>
                    <h5 style="font-size:0.88rem; color:#0f172a;">${comp.subject}</h5>
                    <p style="font-size:0.72rem; color:#64748b;">Category: <strong>${comp.category}</strong> • ${comp.propertyTitle}</p>
                  </div>
                  <span class="hist-status-pill ${comp.status === 'Resolved' ? 'paid' : 'pending'}">${comp.status}</span>
                </div>
                <p style="font-size:0.78rem; color:#334155; margin-top:6px; background:#ffffff; padding:6px 10px; border-radius:6px; border:1px solid #f1f5f9;">
                  "${comp.description}"
                </p>
                ${comp.adminResponse ? `
                  <div style="margin-top:6px; padding:6px 10px; background:#ecfdf5; border-radius:6px; font-size:0.74rem; color:#065f46;">
                    <strong>Admin Response:</strong> ${comp.adminResponse}
                  </div>
                ` : '<div style="margin-top:4px; font-size:0.7rem; color:#94a3b8;">Awaiting owner/admin resolution...</div>'}
              </div>
            `).join('')}
          </div>
        </div>
      </div>
    `;
  }

  // ===================================================================
  // PROPERTY DETAILS MODAL (Sections 8, 9, 10, 16)
  // ===================================================================
  openPropertyDetails(propertyId, roomId) {
    const details = this.state.getPropertyRoomById(propertyId, roomId);
    if (!details) return;

    const { property, room, owner } = details;
    const privacy = this.state.getOwnerContactPermissions(owner.id);
    const isRented = room.status === 'Rented';

    const suitableNames = room.suitableFor.map(sId => {
      const found = this.state.data.customerTypes.find(c => c.id === sId);
      return found ? found.name : sId;
    });

    const modalHTML = `
      <div class="modal-backdrop active" id="property-detail-modal" onclick="if(event.target===this) window.customerApp.closeModal('property-detail-modal')">
        <div class="modal-card-dialog">
          <div class="modal-header">
            <h3>${property.title}</h3>
            <button class="modal-close-btn" onclick="window.customerApp.closeModal('property-detail-modal')">✕</button>
          </div>

          <div class="modal-body" style="padding: 0 0 20px 0;">
            <!-- Gallery Image Carousel -->
            <div style="position:relative; width:100%; height:230px; background:#1e293b;">
              <img id="detail-active-img" src="${(property.gallery && property.gallery.length > 0) ? property.gallery[0] : ((property.images && property.images.length > 0) ? property.images[0] : (room.featuredImage || property.image))}" style="width:100%; height:100%; object-fit:cover; transition:opacity 0.2s ease;" />
              <div style="position:absolute; bottom:12px; left:12px; background:rgba(0,0,0,0.75); color:#fff; padding:4px 10px; border-radius:999px; font-size:0.75rem; font-weight:700;">
                ${room.roomNumber} (${room.roomType.toUpperCase()})
              </div>
              <div style="position:absolute; top:12px; left:12px; background:rgba(0,0,0,0.75); color:#fff; padding:3px 8px; border-radius:999px; font-size:0.72rem; font-weight:700; display:flex; align-items:center; gap:4px;">
                <span>📷</span> <span id="detail-active-photo-idx">Photo 1 of ${((property.gallery && property.gallery.length) || (property.images && property.images.length) || 1)}</span>
              </div>
              <div style="position:absolute; top:12px; right:12px;">
                <span class="badge-status ${isRented ? 'rented' : 'available'}">${room.status}</span>
              </div>
            </div>

            <!-- Gallery Thumbnails Strip -->
            ${((property.gallery && property.gallery.length > 1) || (property.images && property.images.length > 1)) ? `
              <div style="display:flex; gap:8px; overflow-x:auto; padding:8px 16px; background:#f8fafc; border-bottom:1px solid #e2e8f0;">
                ${((property.gallery && property.gallery.length > 0) ? property.gallery : property.images).map((url, idx) => `
                  <div onclick="document.getElementById('detail-active-img').src='${url}'; document.getElementById('detail-active-photo-idx').textContent='Photo ${idx + 1} of ${((property.gallery && property.gallery.length) || property.images.length)}'; document.querySelectorAll('.detail-thumb').forEach(t => t.style.borderColor='#cbd5e1'); this.style.borderColor='#0f766e';" class="detail-thumb" style="flex-shrink:0; width:58px; height:44px; border-radius:6px; overflow:hidden; border:2px solid ${idx === 0 ? '#0f766e' : '#cbd5e1'}; cursor:pointer;">
                    <img src="${url}" style="width:100%; height:100%; object-fit:cover;" />
                  </div>
                `).join('')}
              </div>
            ` : ''}

            <div style="padding:16px 20px;">
              <!-- Price & Deposit Highlight -->
              <div style="display:flex; justify-content:space-between; align-items:flex-end; background:#f8fafc; padding:12px 16px; border-radius:12px; border:1px solid #e2e8f0; margin-bottom:16px;">
                <div>
                  <span style="font-size:0.75rem; color:#64748b; font-weight:600;">Monthly Rent</span>
                  <div style="font-size:1.4rem; font-weight:800; color:var(--primary-dark); font-family:'Outfit',sans-serif;">
                    ₹${room.monthlyRent.toLocaleString('en-IN')}<span style="font-size:0.8rem; font-weight:500; color:#64748b;"> / month</span>
                  </div>
                </div>
                <div style="text-align:right;">
                  <span style="font-size:0.72rem; color:#64748b;">Security Deposit</span>
                  <div style="font-size:1rem; font-weight:700; color:#0f172a;">₹${room.securityDeposit.toLocaleString('en-IN')}</div>
                </div>
              </div>

              <!-- Location & Area Hierarchy (Section 3) -->
              <div style="margin-bottom:14px;">
                <h4 style="font-size:0.95rem; margin-bottom:4px;">Location & Address</h4>
                <p style="font-size:0.82rem; color:#334155;">📍 ${property.address}</p>
                <p style="font-size:0.75rem; color:#64748b; margin-top:2px;">
                  Category: <strong>${property.areaType === 'rural' ? '🌾 Rural / Village Belt' : '🌆 Urban City'}</strong> • Locality: <strong>${property.locality}</strong>
                </p>
              </div>

              <!-- Mandatory Suitable For Checklist (Section 5) -->
              <div style="background:#fffbeb; border:1px solid #fcd34d; border-radius:12px; padding:12px; margin-bottom:16px;">
                <h4 style="font-size:0.85rem; color:#92400e; margin-bottom:6px;">✓ Suitable For (Eligibility Settings)</h4>
                <div style="display:flex; flex-wrap:wrap; gap:6px;">
                  ${suitableNames.map(name => `
                    <span style="background:#fef3c7; color:#92400e; border:1px solid #f59e0b; padding:3px 10px; border-radius:999px; font-size:0.75rem; font-weight:700;">
                      ✓ ${name}
                    </span>
                  `).join('')}
                </div>
              </div>

              <!-- Key Property Specifications -->
              <div style="margin-bottom:16px;">
                <h4 style="font-size:0.95rem; margin-bottom:8px;">Specifications</h4>
                <div style="display:grid; grid-template-columns:1fr 1fr; gap:8px; font-size:0.78rem;">
                  <div style="background:#f1f5f9; padding:8px 10px; border-radius:8px;">
                    <span style="color:#64748b;">Room / Unit:</span><br><strong>${room.roomNumber}</strong>
                  </div>
                  <div style="background:#f1f5f9; padding:8px 10px; border-radius:8px;">
                    <span style="color:#64748b;">Size:</span><br><strong>${room.sizeSqFt}</strong>
                  </div>
                  <div style="background:#f1f5f9; padding:8px 10px; border-radius:8px;">
                    <span style="color:#64748b;">Furnishing:</span><br><strong>${room.furnishing}</strong>
                  </div>
                  <div style="background:#f1f5f9; padding:8px 10px; border-radius:8px;">
                    <span style="color:#64748b;">Available From:</span><br><strong>${room.availableFrom}</strong>
                  </div>
                </div>
              </div>

              <!-- Electricity, Maintenance & Charges (Section 8) -->
              <div style="margin-bottom:16px; font-size:0.8rem;">
                <h4 style="font-size:0.95rem; margin-bottom:6px;">Charges & Utilities</h4>
                <div style="padding:6px 0; border-bottom:1px solid #f1f5f9;">
                  <strong>⚡ Electricity:</strong> ${property.electricityInfo}
                </div>
                <div style="padding:6px 0; border-bottom:1px solid #f1f5f9;">
                  <strong>🧹 Maintenance:</strong> ${property.maintenanceInfo}
                </div>
                <div style="padding:6px 0;">
                  <strong>📋 Other Charges:</strong> ${property.otherCharges}
                </div>
              </div>

              <!-- Amenities -->
              <div style="margin-bottom:16px;">
                <h4 style="font-size:0.95rem; margin-bottom:6px;">Amenities</h4>
                <div style="display:flex; flex-wrap:wrap; gap:6px;">
                  ${property.amenities.map(a => `
                    <span style="background:#f1f5f9; color:#334155; padding:4px 10px; border-radius:6px; font-size:0.75rem; font-weight:600;">
                      ✨ ${a}
                    </span>
                  `).join('')}
                </div>
              </div>

              <!-- Rental Conditions -->
              <div style="background:#f8fafc; border-left:3px solid var(--primary); padding:10px 14px; border-radius:6px; font-size:0.78rem; margin-bottom:16px;">
                <strong>Rental Terms & Conditions:</strong><br>
                ${property.rentalConditions}
              </div>

              <!-- Owner Privacy & Contact Actions (Section 9) -->
              <div style="background:#ffffff; border:1px solid #e2e8f0; border-radius:12px; padding:12px; margin-bottom:16px;">
                <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:8px;">
                  <div>
                    <h5 style="font-size:0.85rem; color:#0f172a;">Property Owner: ${owner.name}</h5>
                    <span style="font-size:0.72rem; color:#64748b;">⭐ ${owner.rating || 4.8} Rating • Verified Host</span>
                  </div>
                  <span style="font-size:0.7rem; color:#0284c7; background:#e0f2fe; padding:2px 8px; border-radius:999px; font-weight:700;">
                    Privacy Active
                  </span>
                </div>

                <!-- Contact Buttons based on Owner Privacy Settings -->
                <div style="display:flex; gap:8px;">
                  ${privacy.canCall ? `
                    <a href="tel:${privacy.phone}" class="btn-primary-sm" style="flex:1; text-align:center; text-decoration:none; background:#0284c7; font-size:0.78rem;">
                      📞 Call Owner
                    </a>
                  ` : `
                    <button class="btn-primary-sm" style="flex:1; background:#e2e8f0; color:#94a3b8; cursor:not-allowed; font-size:0.78rem;" title="Owner has disabled calls">
                      📞 Calls Disabled
                    </button>
                  `}

                  ${privacy.canMessage ? `
                    <a href="mailto:${privacy.email}" class="btn-primary-sm" style="flex:1; text-align:center; text-decoration:none; background:#6366f1; font-size:0.78rem;">
                      💬 Send Message
                    </a>
                  ` : `
                    <button class="btn-primary-sm" style="flex:1; background:#e2e8f0; color:#94a3b8; cursor:not-allowed; font-size:0.78rem;" title="Owner has disabled messages">
                      💬 Message Disabled
                    </button>
                  `}
                </div>
                ${!privacy.canCall && !privacy.canMessage ? `
                  <p style="font-size:0.72rem; color:#64748b; margin-top:6px; text-align:center;">
                    Direct contacts hidden per owner preference. Please submit a Rental Request below.
                  </p>
                ` : ''}
              </div>

              <!-- Main Request for Rent CTA Button (Section 10) -->
              ${isRented ? `
                <button class="btn-primary-sm" style="width:100%; padding:14px; background:#94a3b8; cursor:not-allowed; font-size:0.95rem;" disabled>
                  ❌ Room Currently Rented (Unavailable)
                </button>
              ` : `
                <button class="btn-primary-sm" style="width:100%; padding:14px; font-size:0.95rem; box-shadow:0 4px 14px rgba(15,118,110,0.4);" onclick="window.customerApp.openRentalRequestDialog('${property.id}', '${room.id}')">
                  🚀 Request for Rent (Monthly)
                </button>
              `}
            </div>
          </div>
        </div>
      </div>
    `;

    document.body.insertAdjacentHTML('beforeend', modalHTML);
  }

  // ===================================================================
  // RENTAL REQUEST DIALOG (Section 10)
  // ===================================================================
  openRentalRequestDialog(propertyId, roomId) {
    this.closeModal('property-detail-modal');
    const details = this.state.getPropertyRoomById(propertyId, roomId);
    if (!details) return;

    const { property, room } = details;
    const user = this.state.getCurrentUser();

    const dialogHTML = `
      <div class="modal-backdrop active" id="rental-request-modal" onclick="if(event.target===this) window.customerApp.closeModal('rental-request-modal')">
        <div class="modal-card-dialog">
          <div class="modal-header">
            <h3>Send Rental Request / Booking</h3>
            <button class="modal-close-btn" onclick="window.customerApp.closeModal('rental-request-modal')">✕</button>
          </div>

          <div class="modal-body">
            <div style="background:#f0fdf4; border:1px solid #bbf7d0; border-radius:10px; padding:10px 14px; margin-bottom:14px; font-size:0.8rem; color:#166534;">
              <strong>Property:</strong> ${property.title} (${room.roomNumber})<br>
              <strong>Base Rent:</strong> ₹${room.monthlyRent.toLocaleString('en-IN')}/month • <strong>Deposit:</strong> ₹${room.securityDeposit.toLocaleString('en-IN')}
            </div>

            <form id="rental-request-form" onsubmit="window.customerApp.submitRentalRequest(event, '${property.id}', '${room.id}')">
              <!-- Booking Duration Type (Month / Day / Hour) -->
              <div style="background:#f8fafc; border:1px solid #e2e8f0; border-radius:10px; padding:10px; margin-bottom:12px;">
                <label style="font-size:0.78rem; font-weight:700; color:#0f766e; display:block; margin-bottom:6px;">
                  ⏱️ Select Booking Duration Type:
                </label>
                <div style="display:grid; grid-template-columns:1fr 1fr 1fr; gap:6px; margin-bottom:8px;">
                  <button type="button" class="btn-secondary-sm cr-dur-btn" id="cr-btn-month" onclick="window.customerApp.setCustReqDurationType('month', ${room.monthlyRent})" style="padding:4px; font-size:0.75rem; background:#0f766e; color:#fff;">📅 Month</button>
                  <button type="button" class="btn-secondary-sm cr-dur-btn" id="cr-btn-day" onclick="window.customerApp.setCustReqDurationType('day', ${room.monthlyRent})" style="padding:4px; font-size:0.75rem;">☀️ Day</button>
                  <button type="button" class="btn-secondary-sm cr-dur-btn" id="cr-btn-hour" onclick="window.customerApp.setCustReqDurationType('hour', ${room.monthlyRent})" style="padding:4px; font-size:0.75rem;">⏱️ Hour</button>
                </div>

                <div id="cr-duration-presets" style="display:flex; flex-wrap:wrap; gap:4px; margin-bottom:8px;">
                  <!-- Dynamically populated chips -->
                </div>

                <div style="display:grid; grid-template-columns:1fr 1.5fr; gap:8px;">
                  <div>
                    <label style="font-size:0.72rem; color:#64748b;">Duration Value</label>
                    <input type="number" class="form-control" id="req-duration" value="11" min="1" oninput="window.customerApp.recalcCustReqFinancials(${room.monthlyRent})" style="margin-bottom:0;" />
                  </div>
                  <div>
                    <label style="font-size:0.72rem; color:#64748b;">Expected Move-in / Date</label>
                    <input type="date" class="form-control" id="req-movein-date" required value="${room.availableFrom || new Date().toISOString().split('T')[0]}" style="margin-bottom:0;" />
                  </div>
                </div>

                <div id="cr-calc-summary" style="margin-top:8px; font-size:0.75rem; font-weight:700; color:#0f766e; background:#f0fdfa; padding:6px 8px; border-radius:6px; border:1px solid #99f6e4;">
                  Total Amount: ₹${(room.monthlyRent * 11).toLocaleString('en-IN')} (₹${room.monthlyRent}/mo)
                </div>
              </div>

              <div class="form-group">
                <label>Your Customer Category</label>
                <input type="text" class="form-control" value="${user.customerType || 'Working Professional'}" readonly style="background:#f1f5f9;" />
              </div>

              <div class="form-group">
                <label>Rental Requirements / Message to Owner</label>
                <textarea class="form-control" id="req-message" rows="2" placeholder="Tell the owner about yourself, occupation, move-in plan..."></textarea>
              </div>

              <div style="margin-top:16px; display:flex; gap:10px;">
                <button type="button" class="btn-primary-sm" style="background:#64748b; flex:1;" onclick="window.customerApp.closeModal('rental-request-modal')">Cancel</button>
                <button type="submit" class="btn-primary-sm" style="flex:2;">Submit Request to Owner</button>
              </div>
            </form>
          </div>
        </div>
      </div>
    `;

    document.body.insertAdjacentHTML('beforeend', dialogHTML);
    this.currentReqDurationType = 'month';
    this.setCustReqDurationType('month', room.monthlyRent);
  }

  setCustReqDurationType(type, baseMonthly) {
    this.currentReqDurationType = type;
    const presetsBox = document.getElementById('cr-duration-presets');
    const valInput = document.getElementById('req-duration');
    
    // Update buttons
    ['month', 'day', 'hour'].forEach(t => {
      const btn = document.getElementById(`cr-btn-${t}`);
      if (btn) {
        if (t === type) {
          btn.style.background = '#0f766e';
          btn.style.color = '#fff';
        } else {
          btn.style.background = '';
          btn.style.color = '';
        }
      }
    });

    if (presetsBox && valInput) {
      if (type === 'month') {
        valInput.value = '11';
        presetsBox.innerHTML = [1, 2, 3, 6, 11, 12].map(m => `
          <button type="button" class="btn-secondary-sm" style="padding:2px 8px; font-size:0.7rem;" onclick="document.getElementById('req-duration').value=${m}; window.customerApp.recalcCustReqFinancials(${baseMonthly})">${m} Mo</button>
        `).join('');
      } else if (type === 'day') {
        valInput.value = '3';
        presetsBox.innerHTML = [1, 2, 3, 5, 7, 15, 30].map(d => `
          <button type="button" class="btn-secondary-sm" style="padding:2px 8px; font-size:0.7rem;" onclick="document.getElementById('req-duration').value=${d}; window.customerApp.recalcCustReqFinancials(${baseMonthly})">${d} Days</button>
        `).join('');
      } else if (type === 'hour') {
        valInput.value = '4';
        presetsBox.innerHTML = [1, 2, 3, 4, 6, 8, 12, 24].map(h => `
          <button type="button" class="btn-secondary-sm" style="padding:2px 8px; font-size:0.7rem;" onclick="document.getElementById('req-duration').value=${h}; window.customerApp.recalcCustReqFinancials(${baseMonthly})">${h} Hrs</button>
        `).join('');
      }
    }

    this.recalcCustReqFinancials(baseMonthly);
  }

  recalcCustReqFinancials(baseMonthly) {
    const summaryBox = document.getElementById('cr-calc-summary');
    const valInput = document.getElementById('req-duration');
    if (!summaryBox || !valInput) return;

    const durVal = parseInt(valInput.value, 10) || 1;
    const type = this.currentReqDurationType || 'month';

    let total = baseMonthly;
    if (type === 'hour') {
      const hrRate = Math.max(50, Math.round(baseMonthly / (30 * 6)));
      total = hrRate * durVal;
      summaryBox.textContent = `⏱️ Hourly Stay: ${durVal} Hours · Total Rent: ₹${total.toLocaleString('en-IN')} (₹${hrRate}/hr)`;
    } else if (type === 'day') {
      const dayRate = Math.round(baseMonthly / 30);
      total = dayRate * durVal;
      summaryBox.textContent = `☀️ Daily Stay: ${durVal} Days · Total Rent: ₹${total.toLocaleString('en-IN')} (₹${dayRate}/day)`;
    } else {
      total = baseMonthly * durVal;
      summaryBox.textContent = `📅 Monthly Lease: ${durVal} Months · Total: ₹${total.toLocaleString('en-IN')} (₹${baseMonthly.toLocaleString('en-IN')}/mo)`;
    }
  }

  submitRentalRequest(e, propertyId, roomId) {
    e.preventDefault();
    const moveInDate = document.getElementById('req-movein-date').value;
    const duration = document.getElementById('req-duration').value;
    const msg = document.getElementById('req-message').value;
    const durationType = this.currentReqDurationType || 'month';

    try {
      this.state.createRentalRequest({
        propertyId,
        roomId,
        expectedMoveInDate: moveInDate,
        rentalPeriodMonths: duration,
        bookingDurationType: durationType,
        bookingDurationValue: parseInt(duration, 10) || 1,
        requirements: msg
      });

      this.closeModal('rental-request-modal');
      window.appCoordinator.showToast(`Rental Request (${duration} ${durationType}) successfully sent to Owner!`, 'SUCCESS');
      this.switchTab('rentals');
    } catch (err) {
      alert(err.message);
    }
  }

  // ===================================================================
  // AGREEMENT & AADHAAR KYC MODAL (Section 12 & 13)
  // ===================================================================
  openAgreementSigningModal(requestId) {
    const req = this.state.data.rentalRequests.find(r => r.id === requestId);
    if (!req) return;

    const propDetails = this.state.getPropertyRoomById(req.propertyId, req.roomId);
    const { property, room, owner } = propDetails;
    const user = this.state.getCurrentUser();

    const agreementModalHTML = `
      <div class="modal-backdrop active" id="agreement-signing-modal" onclick="if(event.target===this) window.customerApp.closeModal('agreement-signing-modal')">
        <div class="modal-card-dialog" style="max-width: 580px;">
          <div class="modal-header">
            <h3>Final Terms & Aadhaar Agreement</h3>
            <button class="modal-close-btn" onclick="window.customerApp.closeModal('agreement-signing-modal')">✕</button>
          </div>

          <div class="modal-body">
            <!-- Final Terms Confirmation (Section 12) -->
            <div style="background:#f8fafc; border:1px solid #e2e8f0; border-radius:12px; padding:14px; margin-bottom:16px;">
              <h4 style="font-size:0.92rem; color:#0f172a; margin-bottom:8px;">1. Confirm Final Agreed Terms</h4>
              <div style="display:grid; grid-template-columns:1fr 1fr; gap:8px; font-size:0.8rem;">
                <div><strong>Property:</strong> ${property.title}</div>
                <div><strong>Room/Unit:</strong> ${room.roomNumber}</div>
                <div><strong>Monthly Rent:</strong> ₹${room.monthlyRent.toLocaleString('en-IN')}</div>
                <div><strong>Security Deposit:</strong> ₹${room.securityDeposit.toLocaleString('en-IN')}</div>
                <div><strong>Monthly Due Day:</strong> ${room.dueDayOfMonth || 5}th of every month</div>
                <div><strong>Move-in Date:</strong> ${req.expectedMoveInDate}</div>
              </div>
            </div>

            <!-- Aadhaar KYC & Legal Verification Section (Section 13) -->
            <div style="background:#eff6ff; border:1px solid #bfdbfe; border-radius:12px; padding:14px; margin-bottom:16px;">
              <h4 style="font-size:0.92rem; color:#1e40af; margin-bottom:4px;">2. Aadhaar e-KYC Legal Verification</h4>
              <p style="font-size:0.75rem; color:#1e3a8a; margin-bottom:12px;">
                Required under Legal Tenancy Act for digital agreement generation.
              </p>

              <div class="form-group">
                <label>12-Digit Aadhaar Number</label>
                <input 
                  type="text" 
                  class="form-control" 
                  id="kyc-aadhaar-input" 
                  placeholder="e.g. 5482 9102 4512" 
                  maxlength="14"
                  value="${user.aadhaarVerified ? `XXXX-XXXX-${user.aadhaarLast4 || '4512'}` : '548291024512'}"
                />
              </div>

              <div class="form-group">
                <label>UIDAI OTP (Simulation Test OTP: <strong>123456</strong>)</label>
                <input type="text" class="form-control" id="kyc-otp-input" placeholder="Enter 6-digit OTP (123456)" value="123456" maxlength="6" />
              </div>

              <div style="display:flex; align-items:flex-start; gap:8px; margin-top:10px;">
                <input type="checkbox" id="kyc-consent-check" checked style="margin-top:3px; accent-color:var(--primary); cursor:pointer;" />
                <label for="kyc-consent-check" style="font-size:0.74rem; color:#334155; cursor:pointer;">
                  I hereby provide voluntary consent to authenticate my identity via UIDAI e-KYC service and digitally execute the 11-month rental agreement.
                </label>
              </div>
            </div>

            <!-- Action Button -->
            <button 
              class="btn-primary-sm" 
              style="width:100%; padding:14px; font-size:0.92rem;" 
              onclick="window.customerApp.executeAadhaarAgreement('${req.id}')"
            >
              ✍️ Sign Agreement & Activate Rental
            </button>
          </div>
        </div>
      </div>
    `;

    document.body.insertAdjacentHTML('beforeend', agreementModalHTML);
  }

  executeAadhaarAgreement(requestId) {
    const consent = document.getElementById('kyc-consent-check');
    if (!consent || !consent.checked) {
      alert('Please agree to the e-KYC and digital tenancy agreement consent.');
      return;
    }

    const aadhaarVal = document.getElementById('kyc-aadhaar-input').value;
    const otpVal = document.getElementById('kyc-otp-input').value;

    try {
      const user = this.state.getCurrentUser();
      this.state.performAadhaarKYC(user.id, aadhaarVal.replace(/\s/g, '').replace(/-/g, ''), otpVal);
      this.state.completeRentalAgreement(requestId);

      this.closeModal('agreement-signing-modal');
      window.appCoordinator.showToast('Agreement Signed & Active Rental Initialized!', 'SUCCESS');
      this.switchTab('rentals');
    } catch (err) {
      alert(err.message);
    }
  }

  // ===================================================================
  // DIRECT PROFILE AADHAAR KYC MODAL
  // ===================================================================
  openAadhaarKYCModal() {
    const user = this.state.getCurrentUser();
    const modalHTML = `
      <div class="modal-backdrop active" id="aadhaar-kyc-modal" onclick="if(event.target===this) window.customerApp.closeModal('aadhaar-kyc-modal')">
        <div class="modal-card-dialog" style="max-width: 480px;">
          <div class="modal-header">
            <h3>🇮🇳 Aadhaar e-KYC Identity Verification</h3>
            <button class="modal-close-btn" onclick="window.customerApp.closeModal('aadhaar-kyc-modal')">✕</button>
          </div>
          <div class="modal-body">
            <div style="background:#eff6ff; border:1px solid #bfdbfe; border-radius:12px; padding:14px; margin-bottom:16px;">
              <div style="font-size:0.8rem; color:#1e40af; margin-bottom:10px;">
                Verify your government identity via UIDAI Paperless e-KYC to authenticate your tenant profile.
              </div>
              <div class="form-group">
                <label>12-Digit Aadhaar Number *</label>
                <input type="text" class="form-control" id="direct-aadhaar-input" placeholder="e.g. 5482 9102 4512" maxlength="14" value="${user.aadhaarVerified ? `XXXX-XXXX-${user.aadhaarLast4 || '4512'}` : '548291024512'}" required />
              </div>
              <div class="form-group">
                <label>UIDAI OTP (Test OTP: <strong>123456</strong>) *</label>
                <input type="text" class="form-control" id="direct-aadhaar-otp" placeholder="Enter 6-digit OTP (123456)" value="123456" maxlength="6" required />
              </div>
            </div>
            <button class="btn-primary-sm" style="width:100%; padding:14px; font-size:0.92rem; background:linear-gradient(135deg,#0f766e,#0284c7);" onclick="window.customerApp.submitDirectAadhaarKYC()">
              ✓ Verify & Complete Aadhaar e-KYC
            </button>
          </div>
        </div>
      </div>
    `;
    document.body.insertAdjacentHTML('beforeend', modalHTML);
  }

  submitDirectAadhaarKYC() {
    const aadhaar = document.getElementById('direct-aadhaar-input')?.value;
    const otp = document.getElementById('direct-aadhaar-otp')?.value;
    try {
      const user = this.state.getCurrentUser();
      this.state.performAadhaarKYC(user.id, aadhaar ? aadhaar.replace(/\s/g, '').replace(/-/g, '') : '', otp);
      this.closeModal('aadhaar-kyc-modal');
      window.appCoordinator.showToast('Aadhaar e-KYC Verified Successfully! Profile is now certified.', 'SUCCESS');
      this.switchTab('profile');
    } catch (err) {
      alert(err.message);
    }
  }

  // ===================================================================
  // PAY RENT ONLINE MODAL (Sections 19, 21, 23)
  // ===================================================================
  openPayRentModal(paymentId) {
    const payment = this.state.data.rentPayments.find(p => p.id === paymentId);
    if (!payment) return;

    const modalHTML = `
      <div class="modal-backdrop active" id="pay-rent-modal" onclick="if(event.target===this) window.customerApp.closeModal('pay-rent-modal')">
        <div class="modal-card-dialog">
          <div class="modal-header">
            <h3>💳 Pay Monthly Rent Online</h3>
            <button class="modal-close-btn" onclick="window.customerApp.closeModal('pay-rent-modal')">✕</button>
          </div>

          <div class="modal-body">
            <div style="background:#f8fafc; border:1px solid #e2e8f0; border-radius:12px; padding:14px; text-align:center; margin-bottom:16px;">
              <span style="font-size:0.75rem; color:#64748b;">Rent Month: <strong>${payment.rentMonth}</strong></span>
              <div style="font-size:1.8rem; font-weight:800; color:var(--primary-dark); font-family:'Outfit',sans-serif; margin:4px 0;">
                ₹${payment.rentAmount.toLocaleString('en-IN')}
              </div>
              <span style="font-size:0.72rem; color:#d97706; background:#fef3c7; padding:2px 8px; border-radius:999px; font-weight:700;">
                Due Date: ${payment.dueDate}
              </span>
            </div>

            <!-- Payment Modes (UPI, Cards, Netbanking) -->
            <div class="form-group">
              <label>Select Payment Mode</label>
              <select class="form-control" id="pay-mode-select">
                <option value="UPI">Instant UPI (GPay / PhonePe / Paytm / BHIM)</option>
                <option value="Online">Debit / Credit Card / Netbanking</option>
                <option value="Bank Transfer">Direct IMPS / NEFT Transfer</option>
              </select>
            </div>

            <div class="form-group">
              <label>UPI ID or Transaction Reference</label>
              <input type="text" class="form-control" id="pay-txn-ref" value="UPI-${Math.floor(100000000 + Math.random() * 900000000)}" />
            </div>

            <div style="background:#f1f5f9; border-radius:8px; padding:10px; font-size:0.74rem; color:#475569; margin-bottom:16px;">
              🔒 256-bit encrypted gateway. Instant digital receipt will be generated upon completion.
            </div>

            <button class="btn-primary-sm" style="width:100%; padding:14px; font-size:0.92rem; background:linear-gradient(135deg,#10b981,#059669);" onclick="window.customerApp.submitRentPayment('${payment.id}')">
              Authorize Payment of ₹${payment.rentAmount.toLocaleString('en-IN')}
            </button>
          </div>
        </div>
      </div>
    `;

    document.body.insertAdjacentHTML('beforeend', modalHTML);
  }

  submitRentPayment(paymentId) {
    const mode = document.getElementById('pay-mode-select').value;
    const ref = document.getElementById('pay-txn-ref').value;

    try {
      const updated = this.state.recordRentPayment({
        paymentId,
        paymentMode: mode,
        transactionRef: ref,
        notes: `Paid online by tenant on ${new Date().toLocaleDateString()}`
      });

      this.closeModal('pay-rent-modal');
      window.appCoordinator.showToast('Rent Paid Successfully! Digital Receipt Generated.', 'SUCCESS');
      this.switchTab('rentals');
      // Automatically open receipt
      setTimeout(() => {
        window.appCoordinator.openDigitalReceipt(updated.id);
      }, 400);
    } catch (err) {
      alert(err.message);
    }
  }

  // ===================================================================
  // RECORD CASH PAYMENT MODAL (Section 21 & 23)
  // ===================================================================
  openCashRecordModal(paymentId) {
    const payment = this.state.data.rentPayments.find(p => p.id === paymentId);
    if (!payment) return;

    const modalHTML = `
      <div class="modal-backdrop active" id="cash-rent-modal" onclick="if(event.target===this) window.customerApp.closeModal('cash-rent-modal')">
        <div class="modal-card-dialog">
          <div class="modal-header">
            <h3>💵 Record In-Person Cash Payment</h3>
            <button class="modal-close-btn" onclick="window.customerApp.closeModal('cash-rent-modal')">✕</button>
          </div>

          <div class="modal-body">
            <div style="background:#f8fafc; border:1px solid #e2e8f0; border-radius:12px; padding:12px; margin-bottom:14px; font-size:0.82rem;">
              <strong>Month:</strong> ${payment.rentMonth} • <strong>Amount:</strong> ₹${payment.rentAmount.toLocaleString('en-IN')}
            </div>

            <div class="form-group">
              <label>Cash Handover Date</label>
              <input type="date" class="form-control" id="cash-pay-date" value="${new Date().toISOString().split('T')[0]}" />
            </div>

            <div class="form-group">
              <label>Receipt Note / Receiver Info</label>
              <input type="text" class="form-control" id="cash-pay-note" placeholder="e.g. Handed cash to Owner in person" />
            </div>

            <button class="btn-primary-sm" style="width:100%; padding:12px;" onclick="window.customerApp.submitCashPaymentRecord('${payment.id}')">
              Confirm Cash Payment Record
            </button>
          </div>
        </div>
      </div>
    `;

    document.body.insertAdjacentHTML('beforeend', modalHTML);
  }

  submitCashPaymentRecord(paymentId) {
    const note = document.getElementById('cash-pay-note').value;
    try {
      const updated = this.state.recordRentPayment({
        paymentId,
        paymentMode: 'Cash',
        transactionRef: `CASH-REC-${Math.floor(1000 + Math.random() * 9000)}`,
        notes: note || 'Paid in Cash directly to owner'
      });

      this.closeModal('cash-rent-modal');
      window.appCoordinator.showToast('Cash Payment Recorded & Receipt Saved!', 'SUCCESS');
      this.switchTab('rentals');
    } catch (err) {
      alert(err.message);
    }
  }

  // ===================================================================
  // COMPLAINT MODAL (Section 26 & 28)
  // ===================================================================
  openNewComplaintModal() {
    const modalHTML = `
      <div class="modal-backdrop active" id="complaint-modal" onclick="if(event.target===this) window.customerApp.closeModal('complaint-modal')">
        <div class="modal-card-dialog">
          <div class="modal-header">
            <h3>🛠️ Raise Maintenance / Support Ticket</h3>
            <button class="modal-close-btn" onclick="window.customerApp.closeModal('complaint-modal')">✕</button>
          </div>

          <div class="modal-body">
            <form id="new-complaint-form" onsubmit="window.customerApp.submitComplaint(event)">
              <div class="form-group">
                <label>Category</label>
                <select class="form-control" id="comp-category" required>
                  <option value="Maintenance">Plumbing / Maintenance</option>
                  <option value="Electricity">Electricity / Power Backup</option>
                  <option value="Water Supply">Water Supply / RO</option>
                  <option value="Security / Noise">Security / Society Rules</option>
                  <option value="Rent / Billing">Rent / Billing Query</option>
                  <option value="Other">Other Query</option>
                </select>
              </div>

              <div class="form-group">
                <label>Subject</label>
                <input type="text" class="form-control" id="comp-subject" placeholder="Brief summary of issue" required />
              </div>

              <div class="form-group">
                <label>Description</label>
                <textarea class="form-control" id="comp-desc" rows="3" placeholder="Provide details for owner & admin resolution..." required></textarea>
              </div>

              <button type="submit" class="btn-primary-sm" style="width:100%; padding:12px;">
                Submit Ticket
              </button>
            </form>
          </div>
        </div>
      </div>
    `;

    document.body.insertAdjacentHTML('beforeend', modalHTML);
  }

  submitComplaint(e) {
    e.preventDefault();
    const cat = document.getElementById('comp-category').value;
    const subj = document.getElementById('comp-subject').value;
    const desc = document.getElementById('comp-desc').value;

    this.state.submitComplaint({
      category: cat,
      subject: subj,
      description: desc
    });

    this.closeModal('complaint-modal');
    window.appCoordinator.showToast('Support ticket filed. Owner & Admin notified.', 'SUCCESS');
    this.switchTab('profile');
  }

  // ===================================================================
  // HELPERS & FILTER HANDLERS
  // ===================================================================
  setAreaType(areaType) {
    this.state.setSearchFilters({ areaType, city: '', locality: '' });
    if (this.currentTab !== 'home') this.switchTab('home');
  }

  onCityChange(city) {
    this.state.setSearchFilters({ city, locality: '' });
  }

  onLocalityChange(locality) {
    this.state.setSearchFilters({ locality });
  }

  onSearchQueryChange(searchQuery) {
    this.state.setSearchFilters({ searchQuery });
  }

  setPropertyType(propertyType) {
    this.state.setSearchFilters({ propertyType });
  }

  toggleSuitableType(typeId) {
    const list = [...this.state.searchFilters.suitableFor];
    const idx = list.indexOf(typeId);
    if (idx > -1) {
      list.splice(idx, 1);
    } else {
      list.push(typeId);
    }
    this.state.setSearchFilters({ suitableFor: list });
  }

  clearSuitableFilter() {
    this.state.setSearchFilters({ suitableFor: [] });
  }

  onRentRangeChange(maxRent) {
    this.state.setSearchFilters({ maxRent: parseInt(maxRent, 10) });
  }

  setFurnishing(furnishing) {
    this.state.setSearchFilters({ furnishing });
  }

  toggleOnlyAvailable(onlyAvailable) {
    this.state.setSearchFilters({ onlyAvailable });
  }

  resetAllFilters() {
    this.state.resetSearchFilters();
  }

  toggleSave(propRoomKey) {
    this.state.toggleSaveProperty(propRoomKey);
  }

  closeModal(modalId) {
    const el = document.getElementById(modalId);
    if (el) el.remove();
  }

  attachEventListeners() {
    // Reusable listeners hook
  }
}

if (typeof window !== 'undefined') {
  window.CustomerAppController = CustomerAppController;
}

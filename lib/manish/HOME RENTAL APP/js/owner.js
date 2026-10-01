/**
 * Monthly Home, Room, Apartment & Property Rental Platform
 * Property Owner App Controller & Management Workflows
 */

class OwnerAppController {
  constructor(appState) {
    this.state = appState;
    this.currentTab = 'dashboard'; // 'dashboard' | 'properties' | 'requests' | 'rent' | 'profile'
  }

  render(container) {
    container.innerHTML = `
      <div class="owner-app-root">
        <!-- Dynamic Main Content Based on Active Tab -->
        <div id="owner-tab-content">
          ${this.getTabContentHTML()}
        </div>

        <!-- Mobile Bottom Navigation Bar (Owner) -->
        <nav class="bottom-nav-bar" id="owner-bottom-nav">
          <button class="nav-item-btn ${this.currentTab === 'dashboard' ? 'active' : ''}" onclick="window.ownerApp.switchTab('dashboard')">
            <span class="nav-icon">📊</span>
            <span>Dashboard</span>
          </button>
          <button class="nav-item-btn ${this.currentTab === 'properties' ? 'active' : ''}" onclick="window.ownerApp.switchTab('properties')">
            <span class="nav-icon">🏘️</span>
            <span>Properties</span>
          </button>
          <button class="nav-item-btn ${this.currentTab === 'requests' ? 'active' : ''}" onclick="window.ownerApp.switchTab('requests')">
            <span class="nav-icon">📩</span>
            <span>Requests</span>
          </button>
          <button class="nav-item-btn ${this.currentTab === 'rent' ? 'active' : ''}" onclick="window.ownerApp.switchTab('rent')">
            <span class="nav-icon">💰</span>
            <span>Rent</span>
          </button>
          <button class="nav-item-btn ${this.currentTab === 'profile' ? 'active' : ''}" onclick="window.ownerApp.switchTab('profile')">
            <span class="nav-icon">⚙️</span>
            <span>Settings</span>
          </button>
        </nav>
      </div>
    `;

    this.attachEventListeners();
  }

  switchTab(tabName) {
    this.currentTab = tabName;
    const contentEl = document.getElementById('owner-tab-content');
    if (contentEl) {
      contentEl.innerHTML = this.getTabContentHTML();
      this.attachEventListeners();
    }
    const navBtns = document.querySelectorAll('#owner-bottom-nav .nav-item-btn');
    navBtns.forEach(btn => btn.classList.remove('active'));
    const activeBtn = Array.from(navBtns).find(btn => btn.textContent.toLowerCase().includes(tabName));
    if (activeBtn) activeBtn.classList.add('active');
  }

  getTabContentHTML() {
    switch (this.currentTab) {
      case 'dashboard':
        return this.renderDashboardTab();
      case 'properties':
        return this.renderPropertiesTab();
      case 'requests':
        return this.renderRequestsTab();
      case 'rent':
        return this.renderRentCollectionTab();
      case 'profile':
        return this.renderProfileTab();
      default:
        return this.renderDashboardTab();
    }
  }

  // ===================================================================
  // 1. OWNER DASHBOARD (Section 14 & 27)
  // ===================================================================
  renderDashboardTab() {
    const owner = this.state.getCurrentUser();
    const myProperties = this.state.data.properties.filter(p => p.ownerId === owner.id);

    let totalRooms = 0;
    let availableRooms = 0;
    let rentedRooms = 0;

    myProperties.forEach(p => {
      p.rooms.forEach(r => {
        totalRooms++;
        if (r.status === 'Available') availableRooms++;
        if (r.status === 'Rented') rentedRooms++;
      });
    });

    const myRequests = this.state.data.rentalRequests.filter(r => r.ownerId === owner.id);
    const pendingReqs = myRequests.filter(r => r.status === 'Pending').length;

    const myPayments = this.state.data.rentPayments.filter(p => p.ownerId === owner.id);
    const collectedRent = myPayments.filter(p => p.paymentStatus === 'Paid').reduce((s, p) => s + p.rentAmount, 0);
    const pendingRent = myPayments.filter(p => p.paymentStatus === 'Pending').reduce((s, p) => s + p.rentAmount, 0);

    return `
      <div class="owner-dashboard-container">
        <!-- Top Welcome Header -->
        <div style="background:linear-gradient(135deg,#1e293b 0%,#0f172a 100%); color:#fff; padding:18px; border-radius:20px; box-shadow:var(--shadow-md);">
          <div style="display:flex; justify-content:space-between; align-items:center;">
            <div>
              <span style="font-size:0.75rem; color:#94a3b8;">Owner Portal</span>
              <h2 style="font-size:1.3rem; color:#fff;">${owner.name}</h2>
              <p style="font-size:0.78rem; color:#cbd5e1;">⭐ ${owner.rating || 4.8} Rating • ${myProperties.length} Properties Managed</p>
            </div>
            <button class="btn-primary-sm" style="background:linear-gradient(135deg,#0f766e,#10b981);" onclick="window.ownerApp.openAddPropertyModal()">
              + Add Property
            </button>
          </div>
        </div>

        <!-- Metric Cards Grid (Section 14) -->
        <div class="owner-hero-stats-grid">
          <div class="owner-stat-card">
            <div class="stat-icon-wrap emerald">🏢</div>
            <div>
              <div class="stat-number">${myProperties.length}</div>
              <div class="stat-title">Total Properties (${totalRooms} Units)</div>
            </div>
          </div>

          <div class="owner-stat-card">
            <div class="stat-icon-wrap blue">🔑</div>
            <div>
              <div class="stat-number">${rentedRooms} / ${totalRooms}</div>
              <div class="stat-title">Rented Units (${availableRooms} Avail)</div>
            </div>
          </div>

          <div class="owner-stat-card">
            <div class="stat-icon-wrap purple">📩</div>
            <div>
              <div class="stat-number">${pendingReqs}</div>
              <div class="stat-title">Pending Inquiries</div>
            </div>
          </div>

          <div class="owner-stat-card">
            <div class="stat-icon-wrap amber">💰</div>
            <div>
              <div class="stat-number">₹${(collectedRent / 1000).toFixed(1)}k</div>
              <div class="stat-title">Collected (₹${(pendingRent / 1000).toFixed(1)}k Due)</div>
            </div>
          </div>
        </div>

        <!-- Quick Pending Action Alert -->
        ${pendingReqs > 0 ? `
          <div style="background:#fffbeb; border:1px solid #fcd34d; border-radius:14px; padding:14px; display:flex; justify-content:space-between; align-items:center;">
            <div>
              <h4 style="font-size:0.9rem; color:#92400e;">${pendingReqs} Rental Request(s) Awaiting Decision</h4>
              <p style="font-size:0.75rem; color:#78350f;">Review customer profiles and accept or reject requests.</p>
            </div>
            <button class="btn-primary-sm" style="background:#d97706;" onclick="window.ownerApp.switchTab('requests')">
              Review Now
            </button>
          </div>
        ` : ''}

        <!-- Property Overview Section -->
        <div>
          <div class="section-header-title">
            <h3>My Properties & Room Status</h3>
            <a href="javascript:void(0)" onclick="window.ownerApp.switchTab('properties')">View All (${myProperties.length})</a>
          </div>

          <div style="display:flex; flex-direction:column; gap:12px; margin-top:8px;">
            ${myProperties.map(p => this.renderOwnerPropertySnippet(p)).join('')}
          </div>
        </div>
      </div>
    `;
  }

  renderOwnerPropertySnippet(property) {
    return `
      <div class="owner-property-manage-card">
        <div class="manage-card-header">
          <div>
            <h4 style="font-size:0.95rem; color:#0f172a;">${property.title}</h4>
            <span style="font-size:0.72rem; color:#64748b;">📍 ${property.locality}, ${property.city} • ${property.propertyType.toUpperCase()}</span>
          </div>
          <button class="btn-primary-sm" style="font-size:0.72rem; padding:4px 10px;" onclick="window.ownerApp.openAddRoomModal('${property.id}')">
            + Add Room
          </button>
        </div>

        <div class="manage-rooms-list">
          ${property.rooms.map(room => {
            const isRented = room.status === 'Rented';
            const tenant = isRented ? this.state.data.users.find(u => u.id === room.currentTenantId) : null;

            return `
              <div class="manage-room-row">
                <div>
                  <div style="font-weight:700; font-size:0.85rem; color:#1e293b;">
                    ${room.roomNumber} <span style="font-weight:400; font-size:0.75rem; color:#64748b;">(${room.roomType.toUpperCase()})</span>
                  </div>
                  <div style="font-size:0.75rem; color:#64748b;">
                    ₹${room.monthlyRent.toLocaleString('en-IN')}/mo • Due on ${room.dueDayOfMonth || 5}th
                    ${tenant ? ` • 👤 Tenant: <strong>${tenant.name}</strong>` : ''}
                  </div>
                </div>

                <div style="display:flex; align-items:center; gap:8px;">
                  <span class="badge-status ${isRented ? 'rented' : (room.status === 'Available' ? 'available' : 'pending')}">
                    ${room.status}
                  </span>
                </div>
              </div>
            `;
          }).join('')}
        </div>
      </div>
    `;
  }

  // ===================================================================
  // 2. PROPERTIES TAB (Section 15, 16, 17, 18)
  // ===================================================================
  renderPropertiesTab() {
    const owner = this.state.getCurrentUser();
    const myProperties = this.state.data.properties.filter(p => p.ownerId === owner.id);

    return `
      <div style="padding: 20px 18px 30px;">
        <div class="section-header-title">
          <h2>🏘️ Property Portfolio</h2>
          <button class="btn-primary-sm" onclick="window.ownerApp.openAddPropertyModal()">
            + Add New Property
          </button>
        </div>

        <div style="display:flex; flex-direction:column; gap:16px; margin-top:14px;">
          ${myProperties.length === 0 ? `
            <div style="text-align:center; padding:40px; background:#fff; border-radius:16px; border:1px solid #e2e8f0;">
              <h4>No Properties Listed Yet</h4>
              <p style="font-size:0.8rem; color:#64748b; margin-top:4px;">List your apartments, houses, PG rooms or godowns to start receiving verified rental requests.</p>
              <button class="btn-primary-sm" style="margin-top:16px;" onclick="window.ownerApp.openAddPropertyModal()">Add First Property</button>
            </div>
          ` : myProperties.map(p => this.renderOwnerPropertySnippet(p)).join('')}
        </div>
      </div>
    `;
  }

  // ===================================================================
  // 3. RENTAL REQUESTS TAB (Section 10, 11)
  // ===================================================================
  renderRequestsTab() {
    const owner = this.state.getCurrentUser();
    const myRequests = this.state.data.rentalRequests.filter(r => r.ownerId === owner.id);

    return `
      <div style="padding: 20px 18px 30px;">
        <div class="section-header-title">
          <h2>📩 Tenant Rental Inquiries</h2>
          <span class="badge-counter">${myRequests.length} Total</span>
        </div>

        <div style="display:flex; flex-direction:column; gap:14px; margin-top:14px;">
          ${myRequests.length === 0 ? `
            <div style="text-align:center; padding:40px; background:#fff; border-radius:16px; border:1px solid #e2e8f0;">
              <h4>No Rental Inquiries Currently</h4>
              <p style="font-size:0.8rem; color:#64748b; margin-top:4px;">New tenant requests will appear here with complete background & eligibility details.</p>
            </div>
          ` : myRequests.map(req => {
            const propDetails = this.state.getPropertyRoomById(req.propertyId, req.roomId);
            const cust = this.state.data.users.find(u => u.id === req.customerId);

            return `
              <div style="background:#fff; border-radius:16px; padding:16px; border:1px solid #e2e8f0; box-shadow:var(--shadow-sm);">
                <div style="display:flex; justify-content:space-between; align-items:flex-start;">
                  <div>
                    <h4 style="font-size:1rem; color:#0f172a;">${cust ? cust.name : 'Prospective Tenant'}</h4>
                    <span style="font-size:0.75rem; color:#64748b;">
                      Category: <strong>${cust ? cust.customerType : 'Single'}</strong> • 📱 +91 ${cust ? cust.mobile : 'XXXXX'}
                    </span>
                    <div style="margin-top:2px;">
                      <span style="background:${cust && cust.aadhaarVerified ? '#d1fae5' : '#fee2e2'}; color:${cust && cust.aadhaarVerified ? '#065f46' : '#991b1b'}; font-size:0.68rem; font-weight:800; padding:2px 6px; border-radius:999px;">
                        ${cust && cust.aadhaarVerified ? '✓ Aadhaar Verified Profile' : '⚠️ Unverified'}
                      </span>
                    </div>
                  </div>
                  <span class="badge-status ${req.status === 'Accepted' ? 'available' : (req.status === 'Rejected' ? 'rented' : 'pending')}">
                    ${req.status}
                  </span>
                </div>

                <!-- Request Details -->
                <div style="background:#f8fafc; border-radius:10px; padding:10px 12px; margin:12px 0; font-size:0.8rem; border:1px solid #f1f5f9;">
                  <div><strong>Requested Property:</strong> ${propDetails ? propDetails.property.title : 'Property'} (${propDetails ? propDetails.room.roomNumber : ''})</div>
                  <div><strong>Expected Move-in:</strong> ${req.expectedMoveInDate} • <strong>Duration:</strong> ${req.rentalPeriodMonths} Months</div>
                  <div style="margin-top:4px; font-style:italic; color:#475569;">"${req.requirements || 'No additional message provided.'}"</div>
                </div>

                <!-- Decision Actions (Section 11) -->
                ${req.status === 'Pending' ? `
                  <div style="display:flex; gap:10px;">
                    <button class="btn-primary-sm" style="flex:1; background:#ef4444;" onclick="window.ownerApp.respondRequest('${req.id}', 'REJECT')">
                      ✕ Reject Request
                    </button>
                    <button class="btn-primary-sm" style="flex:2; background:#10b981;" onclick="window.ownerApp.respondRequest('${req.id}', 'ACCEPT')">
                      ✓ Accept & Move to Terms
                    </button>
                  </div>
                ` : `
                  <div style="font-size:0.75rem; color:#64748b; text-align:right;">
                    Decision Recorded: <strong>${req.status}</strong>
                  </div>
                `}
              </div>
            `;
          }).join('')}
        </div>
      </div>
    `;
  }

  respondRequest(requestId, decision) {
    this.state.ownerRespondToRequest(requestId, decision);
    window.appCoordinator.showToast(
      decision === 'ACCEPT' ? 'Rental Request Accepted! Moved to final terms.' : 'Rental Request Rejected.',
      decision === 'ACCEPT' ? 'SUCCESS' : 'INFO'
    );
    this.switchTab('requests');
  }

  // ===================================================================
  // 4. RENT COLLECTION & LEDGER TAB (Section 19, 22, 23, 24)
  // ===================================================================
  renderRentCollectionTab() {
    const owner = this.state.getCurrentUser();
    const myActiveRentals = this.state.data.activeRentals.filter(r => r.ownerId === owner.id && r.status === 'Active');
    const myPayments = this.state.data.rentPayments.filter(p => p.ownerId === owner.id);

    return `
      <div class="rent-dashboard-container">
        <div class="section-header-title">
          <h2>💰 Rent Collection Tracker</h2>
          <span class="badge-counter">${myActiveRentals.length} Active Leases</span>
        </div>

        <!-- Active Leases List -->
        <div style="display:flex; flex-direction:column; gap:14px;">
          ${myActiveRentals.length === 0 ? `
            <div style="text-align:center; padding:30px; background:#fff; border-radius:16px; border:1px solid #e2e8f0;">
              <h4>No Active Tenants Currently</h4>
              <p style="font-size:0.78rem; color:#64748b; margin-top:4px;">When an agreement is signed, rent tracking and payment recording will activate here.</p>
            </div>
          ` : myActiveRentals.map(rental => {
            const tenant = this.state.data.users.find(u => u.id === rental.customerId);
            const pendingPay = myPayments.find(p => p.rentalId === rental.id && p.paymentStatus === 'Pending');

            return `
              <div style="background:#fff; border-radius:16px; padding:16px; border:1px solid #e2e8f0; box-shadow:var(--shadow-sm);">
                <div style="display:flex; justify-content:space-between; align-items:flex-start;">
                  <div>
                    <h4 style="font-size:1rem; color:#0f172a;">${rental.propertySnapshot.title}</h4>
                    <p style="font-size:0.78rem; color:#64748b;">Unit: <strong>${rental.propertySnapshot.roomNumber}</strong> • Tenant: <strong>${tenant ? tenant.name : 'Tenant'}</strong></p>
                  </div>
                  <div class="hist-status-pill ${pendingPay ? 'pending' : 'paid'}">
                    ${pendingPay ? 'Rent Due' : 'Rent Received'}
                  </div>
                </div>

                <div style="display:grid; grid-template-columns:1fr 1fr 1fr; gap:8px; background:#f8fafc; padding:10px; border-radius:10px; margin:12px 0; font-size:0.75rem;">
                  <div><span style="color:#64748b;">Monthly Rent:</span><br><strong>₹${rental.monthlyRent.toLocaleString('en-IN')}</strong></div>
                  <div><span style="color:#64748b;">Due Day:</span><br><strong>${rental.monthlyDueDay}th / month</strong></div>
                  <div><span style="color:#64748b;">Deposit:</span><br><strong>₹${rental.securityDeposit.toLocaleString('en-IN')}</strong></div>
                </div>

                <!-- Payment Recording Actions for Owner (Section 22) -->
                ${pendingPay ? `
                  <div style="display:flex; gap:8px;">
                    <button class="btn-primary-sm" style="flex:2; background:#10b981;" onclick="window.ownerApp.openRecordPaymentModal('${pendingPay.id}')">
                      💵 Record Rent Received
                    </button>
                    <button class="btn-primary-sm" style="flex:1; background:#f59e0b;" onclick="window.ownerApp.sendRentReminder('${rental.id}')">
                      🔔 Send Reminder
                    </button>
                  </div>
                ` : `
                  <div style="display:flex; justify-content:space-between; align-items:center; font-size:0.75rem; color:#059669;">
                    <span>✓ Current month rent recorded as Paid.</span>
                    <button class="btn-receipt-download" onclick="window.ownerApp.sendRentReminder('${rental.id}')">Send Receipt</button>
                  </div>
                `}
              </div>
            `;
          }).join('')}
        </div>

        <!-- Master Rent Ledger Table (Section 20 & 22) -->
        <div class="rent-history-section">
          <div class="section-header-title">
            <h3>Recent Received Rent Ledger</h3>
            <span style="font-size:0.75rem; color:#64748b;">Audit History</span>
          </div>

          <div class="history-timeline-list">
            ${myPayments.length === 0 ? `
              <p style="font-size:0.8rem; color:#94a3b8; text-align:center; padding:12px 0;">No payment entries found.</p>
            ` : myPayments.map(p => `
              <div class="history-item-card">
                <div class="history-left-info">
                  <div class="hist-month">${p.rentMonth}</div>
                  <div class="hist-details">
                    Mode: <strong>${p.paymentMode || 'Pending'}</strong> • Date: ${p.paymentDate || `Due ${p.dueDate}`}
                  </div>
                </div>
                <div class="history-right-action">
                  <div class="hist-amount">₹${p.rentAmount.toLocaleString('en-IN')}</div>
                  <span class="hist-status-pill ${p.paymentStatus.toLowerCase()}">${p.paymentStatus}</span>
                  ${p.paymentStatus === 'Paid' ? `
                    <div>
                      <button class="btn-receipt-download" onclick="window.appCoordinator.openDigitalReceipt('${p.id}')">
                        📄 Receipt
                      </button>
                    </div>
                  ` : ''}
                </div>
              </div>
            `).join('')}
          </div>
        </div>
      </div>
    `;
  }

  sendRentReminder(rentalId) {
    const rental = this.state.data.activeRentals.find(r => r.id === rentalId);
    if (!rental) return;

    this.state.addNotification({
      recipientId: rental.customerId,
      recipientRole: 'CUSTOMER',
      title: 'Monthly Rent Reminder from Owner',
      message: `Friendly reminder from owner: Monthly rent of ₹${rental.monthlyRent.toLocaleString('en-IN')} for ${rental.propertySnapshot.title} is pending.`,
      type: 'RENT_REMINDER'
    });

    window.appCoordinator.showToast('Rent reminder notification & alert sent to tenant!', 'SUCCESS');
  }

  // ===================================================================
  // 5. PROFILE & PRIVACY / CONTACT SETTINGS (Section 9 & 27)
  // ===================================================================
  renderProfileTab() {
    const owner = this.state.getCurrentUser();
    const settings = owner.contactSettings || 'CALL_MSG_ON';

    return `
      <div style="padding: 20px 18px 30px;">
        <!-- Owner Profile Header -->
        <div style="background:#fff; border-radius:16px; padding:18px; border:1px solid #e2e8f0; display:flex; align-items:center; gap:16px; margin-bottom:16px;">
          <div style="width:56px; height:56px; border-radius:50%; background:#fef3c7; display:flex; align-items:center; justify-content:center; font-size:2rem;">
            ${owner.avatar || '👨‍🏫'}
          </div>
          <div>
            <h3 style="font-size:1.15rem; margin-bottom:2px;">${owner.name}</h3>
            <p style="font-size:0.8rem; color:#64748b;">📱 +91 ${owner.mobile} • ${owner.email}</p>
            <span style="background:#d1fae5; color:#065f46; font-size:0.7rem; font-weight:700; padding:2px 8px; border-radius:999px;">
              ✓ Verified Property Host
            </span>
          </div>
        </div>

        <!-- Privacy & Contact Settings (Section 9) -->
        <div style="background:#fff; border-radius:16px; padding:18px; border:1px solid #e2e8f0; margin-bottom:16px;">
          <div class="section-header-title">
            <h3>🔒 Tenant Contact & Privacy Controls</h3>
          </div>
          <p style="font-size:0.78rem; color:#64748b; margin-bottom:14px;">
            Choose how prospective and active tenants can contact you directly from property pages.
          </p>

          <div style="display:flex; flex-direction:column; gap:10px;">
            <label style="display:flex; align-items:center; gap:10px; padding:10px 12px; border:1px solid #e2e8f0; border-radius:10px; cursor:pointer; background:${settings === 'CALL_MSG_ON' ? '#f0fdf4' : '#fff'};">
              <input type="radio" name="contact-setting" value="CALL_MSG_ON" ${settings === 'CALL_MSG_ON' ? 'checked' : ''} onchange="window.ownerApp.updateContactPrivacy(this.value)" style="accent-color:var(--primary);" />
              <div>
                <strong style="font-size:0.85rem; color:#0f172a;">Option 1: Phone Calls + In-App Messages ON</strong>
                <div style="font-size:0.72rem; color:#64748b;">Tenants can call your mobile or send direct messages.</div>
              </div>
            </label>

            <label style="display:flex; align-items:center; gap:10px; padding:10px 12px; border:1px solid #e2e8f0; border-radius:10px; cursor:pointer; background:${settings === 'CALL_ON_MSG_OFF' ? '#f0fdf4' : '#fff'};">
              <input type="radio" name="contact-setting" value="CALL_ON_MSG_OFF" ${settings === 'CALL_ON_MSG_OFF' ? 'checked' : ''} onchange="window.ownerApp.updateContactPrivacy(this.value)" style="accent-color:var(--primary);" />
              <div>
                <strong style="font-size:0.85rem; color:#0f172a;">Option 2: Phone Calls ON / Messages OFF</strong>
                <div style="font-size:0.72rem; color:#64748b;">Direct phone calls only; message button disabled.</div>
              </div>
            </label>

            <label style="display:flex; align-items:center; gap:10px; padding:10px 12px; border:1px solid #e2e8f0; border-radius:10px; cursor:pointer; background:${settings === 'CALL_OFF_MSG_ON' ? '#f0fdf4' : '#fff'};">
              <input type="radio" name="contact-setting" value="CALL_OFF_MSG_ON" ${settings === 'CALL_OFF_MSG_ON' ? 'checked' : ''} onchange="window.ownerApp.updateContactPrivacy(this.value)" style="accent-color:var(--primary);" />
              <div>
                <strong style="font-size:0.85rem; color:#0f172a;">Option 3: Phone Calls OFF / Messages ON</strong>
                <div style="font-size:0.72rem; color:#64748b;">Direct messaging only; phone number remains private.</div>
              </div>
            </label>

            <label style="display:flex; align-items:center; gap:10px; padding:10px 12px; border:1px solid #e2e8f0; border-radius:10px; cursor:pointer; background:${settings === 'BOTH_OFF' ? '#f0fdf4' : '#fff'};">
              <input type="radio" name="contact-setting" value="BOTH_OFF" ${settings === 'BOTH_OFF' ? 'checked' : ''} onchange="window.ownerApp.updateContactPrivacy(this.value)" style="accent-color:var(--primary);" />
              <div>
                <strong style="font-size:0.85rem; color:#0f172a;">Option 4: Both OFF (Maximum Privacy)</strong>
                <div style="font-size:0.72rem; color:#64748b;">Personal details completely hidden. Only formal platform Rental Requests allowed.</div>
              </div>
            </label>
          </div>
        </div>
      </div>
    `;
  }

  updateContactPrivacy(setting) {
    const owner = this.state.getCurrentUser();
    this.state.updateOwnerContactSettings(owner.id, setting);
    window.appCoordinator.showToast('Privacy & contact settings updated successfully.', 'SUCCESS');
  }

  // ===================================================================
  // ADD PROPERTY MODAL WIZARD (Section 15 & 16)
  // ===================================================================
  openAddPropertyModal() {
    const modalHTML = `
      <div class="modal-backdrop active" id="add-property-modal" onclick="if(event.target===this) window.ownerApp.closeModal('add-property-modal')">
        <div class="modal-card-dialog" style="max-width: 600px;">
          <div class="modal-header">
            <h3>🏢 Add New Property / Room Listing</h3>
            <button class="modal-close-btn" onclick="window.ownerApp.closeModal('add-property-modal')">✕</button>
          </div>

          <div class="modal-body">
            <form id="add-property-form" onsubmit="window.ownerApp.submitNewProperty(event)">
              <!-- Property Title & Category -->
              <div class="form-group">
                <label>Property Name / Building Title *</label>
                <input type="text" class="form-control" id="prop-title" placeholder="e.g. Ganga Heights Deluxe Residency" required />
              </div>

              <div style="display:grid; grid-template-columns:1fr 1fr; gap:10px;">
                <div class="form-group">
                  <label>Property Type *</label>
                  <select class="form-control" id="prop-type" required>
                    ${this.state.data.propertyTypes.map(t => `<option value="${t.id}">${t.icon} ${t.name}</option>`).join('')}
                  </select>
                </div>
                <div class="form-group">
                  <label>Location Category *</label>
                  <select class="form-control" id="prop-area-type" required onchange="window.ownerApp.onAddAreaTypeChange(this.value)">
                    <option value="urban">🌆 Urban City</option>
                    <option value="rural">🌾 Rural / Village Belt</option>
                  </select>
                </div>
              </div>

              <!-- Location Hierarchy -->
              <div style="display:grid; grid-template-columns:1fr 1fr; gap:10px;">
                <div class="form-group">
                  <label>City / Rural District *</label>
                  <input type="text" class="form-control" id="prop-city" placeholder="e.g. Varanasi" required />
                </div>
                <div class="form-group">
                  <label>Area / Locality / Village *</label>
                  <input type="text" class="form-control" id="prop-locality" placeholder="e.g. Lanka or Harahua Village" required />
                </div>
              </div>

              <div class="form-group">
                <label>Complete Property Address *</label>
                <input type="text" class="form-control" id="prop-address" placeholder="Door No, Street, Landmark, Pin code" required />
              </div>

              <!-- Room / Unit Details with Multi-Room Selector (Kitna Room Hai?) -->
              <div style="background:#f8fafc; border:1px solid #e2e8f0; border-radius:12px; padding:12px; margin-bottom:14px;">
                <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:8px;">
                  <h4 style="font-size:0.88rem; color:#0f766e; margin:0; font-weight:700;">🚪 Unit / Room Specifications</h4>
                  <span id="owner-room-count-badge" style="background:#ccfbf1; color:#0f766e; padding:2px 8px; border-radius:999px; font-size:0.75rem; font-weight:700;">
                    5 Rooms Total
                  </span>
                </div>



                <div style="display:grid; grid-template-columns:1fr 1fr; gap:8px;">
                  <div class="form-group" style="margin-bottom:0;">
                    <label>Room Category</label>
                    <select class="form-control" id="room-type">
                      <option value="room">Single Room</option>
                      <option value="1bhk">1 BHK</option>
                      <option value="2bhk">2 BHK</option>
                      <option value="3bhk">3 BHK</option>
                      <option value="other">Other Unit</option>
                    </select>
                  </div>
                  <div class="form-group" style="margin-bottom:0;">
                    <label>Size (sq.ft)</label>
                    <input type="text" class="form-control" id="room-size" value="480 sq.ft" />
                  </div>
                </div>

                <div style="display:grid; grid-template-columns:1fr 1fr 1fr; gap:8px; margin-top:8px;">
                  <div class="form-group" style="margin-bottom:0;">
                    <label>Monthly Rent (₹) *</label>
                    <input type="number" class="form-control" id="room-rent" value="8500" required />
                  </div>
                  <div class="form-group" style="margin-bottom:0;">
                    <label>Deposit (₹) *</label>
                    <input type="number" class="form-control" id="room-deposit" value="17000" required />
                  </div>
                  <div class="form-group" style="margin-bottom:0;">
                    <label>Monthly Due Day *</label>
                    <select class="form-control" id="room-due-day">
                      <option value="1">1st of Month</option>
                      <option value="5" selected>5th of Month</option>
                      <option value="7">7th of Month</option>
                      <option value="10">10th of Month</option>
                    </select>
                  </div>
                </div>
              </div>

              <!-- Mandatory "Suitable For" Eligibility (Section 16) -->
              <div class="form-group">
                <label>Eligible Customer Types (Suitable For) *</label>
                <div class="suitable-tag-pills" id="add-prop-suitable-box">
                  ${this.state.data.customerTypes.map(ct => `
                    <label class="suitable-pill" style="cursor:pointer;">
                      <input type="checkbox" name="add-suitable" value="${ct.id}" checked style="margin-right:4px;" />
                      ${ct.name}
                    </label>
                  `).join('')}
                </div>
              </div>

              <!-- Utilities & Details -->
              <div class="form-group">
                <label>Electricity Details</label>
                <input type="text" class="form-control" id="prop-elec" value="Sub-meter installed. Billed at ₹7.50 per unit." />
              </div>

              <div class="form-group">
                <label>Maintenance Info</label>
                <input type="text" class="form-control" id="prop-maint" value="₹500/month includes water & cleaning." />
              </div>

              <!-- Multiple Property Photos Section -->
              <div style="background:#f0fdfa; border:1px solid #99f6e4; border-radius:12px; padding:12px; margin-bottom:14px;">
                <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:6px;">
                  <h4 style="font-size:0.88rem; color:#0f766e; margin:0; font-weight:700;">📷 Property Photos (Multiple)</h4>
                  <span id="owner-photo-count-badge" style="background:#ccfbf1; color:#0f766e; padding:2px 8px; border-radius:999px; font-size:0.75rem; font-weight:700;">
                    3 Attached
                  </span>
                </div>
                <p style="font-size:0.75rem; color:#64748b; margin-bottom:8px;">Pick instant presets or paste custom photo URLs:</p>

                <!-- Quick Presets -->
                <div style="display:flex; flex-wrap:wrap; gap:6px; margin-bottom:10px;">
                  <button type="button" class="btn-secondary-sm" style="font-size:0.75rem; padding:3px 8px;" onclick="window.ownerApp.addPhotoFromPreset('https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?auto=format&fit=crop&w=800&q=80', 'Living Room')">+ Living Room</button>
                  <button type="button" class="btn-secondary-sm" style="font-size:0.75rem; padding:3px 8px;" onclick="window.ownerApp.addPhotoFromPreset('https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?auto=format&fit=crop&w=800&q=80', 'Bedroom')">+ Bedroom</button>
                  <button type="button" class="btn-secondary-sm" style="font-size:0.75rem; padding:3px 8px;" onclick="window.ownerApp.addPhotoFromPreset('https://images.unsplash.com/photo-1556911220-e15b29be8c8f?auto=format&fit=crop&w=800&q=80', 'Kitchen')">+ Kitchen</button>
                  <button type="button" class="btn-secondary-sm" style="font-size:0.75rem; padding:3px 8px;" onclick="window.ownerApp.addPhotoFromPreset('https://images.unsplash.com/photo-1545324418-cc1a3fa10c00?auto=format&fit=crop&w=800&q=80', 'Exterior')">+ Exterior</button>
                  <button type="button" class="btn-secondary-sm" style="font-size:0.75rem; padding:3px 8px;" onclick="window.ownerApp.addPhotoFromPreset('https://images.unsplash.com/photo-1512917774080-9991f1c4c750?auto=format&fit=crop&w=800&q=80', 'Balcony')">+ Balcony</button>
                </div>

                <!-- Custom URL input -->
                <div style="display:flex; gap:6px; margin-bottom:10px;">
                  <input type="text" class="form-control" id="owner-new-photo-url" placeholder="Paste photo URL (https://...)" style="margin-bottom:0;" />
                  <button type="button" class="btn-primary-sm" style="white-space:nowrap; padding:6px 12px;" onclick="window.ownerApp.addCustomPhoto()">Add Photo</button>
                </div>

                <!-- Gallery Thumbnails Preview Strip -->
                <div id="owner-photo-gallery-preview" style="display:flex; gap:8px; overflow-x:auto; padding-bottom:4px;">
                  <!-- Rendered dynamically -->
                </div>
              </div>

              <button type="submit" class="btn-primary-sm" style="width:100%; padding:14px; font-size:0.95rem;">
                Publish Property Listing
              </button>
            </form>
          </div>
        </div>
      </div>
    `;

    document.body.insertAdjacentHTML('beforeend', modalHTML);

    this.tempOwnerRooms = ['Room 1', 'Room 2', 'Room 3', 'Room 4', 'Room 5'];
    this.tempOwnerFormat123 = true;
    this.tempOwnerFormat100 = false;
    this.tempOwnerRoomCount = 5;
    this.renderOwnerRoomsPreview();

    this.tempOwnerPhotos = [
      'https://images.unsplash.com/photo-1545324418-cc1a3fa10c00?auto=format&fit=crop&w=800&q=80',
      'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?auto=format&fit=crop&w=800&q=80',
      'https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?auto=format&fit=crop&w=800&q=80'
    ];
    this.renderOwnerPhotosPreview();
  }

  setRoomCount(count) {
    this.tempOwnerRoomCount = count;
    this.rebuildOwnerRooms();
  }

  toggleRoomStyle(style) {
    if (style === '123') {
      if (this.tempOwnerFormat123 && !this.tempOwnerFormat100) return;
      this.tempOwnerFormat123 = !this.tempOwnerFormat123;
    } else if (style === '100') {
      if (this.tempOwnerFormat100 && !this.tempOwnerFormat123) return;
      this.tempOwnerFormat100 = !this.tempOwnerFormat100;
    }
    this.rebuildOwnerRooms();
  }

  rebuildOwnerRooms() {
    this.tempOwnerRooms = [];
    const count = this.tempOwnerRoomCount || 5;
    if (this.tempOwnerFormat123) {
      for (let i = 1; i <= count; i++) {
        this.tempOwnerRooms.push(`Room ${i}`);
      }
    }
    if (this.tempOwnerFormat100) {
      for (let i = 1; i <= count; i++) {
        this.tempOwnerRooms.push(`Room ${100 + i}`);
      }
    }
    if (this.tempOwnerRooms.length === 0) {
      this.tempOwnerRooms.push('Room 1');
    }

    const btn123 = document.getElementById('owner-fmt-123-btn');
    const btn100 = document.getElementById('owner-fmt-100-btn');
    if (btn123) {
      btn123.style.background = this.tempOwnerFormat123 ? '#0f766e' : '';
      btn123.style.color = this.tempOwnerFormat123 ? '#fff' : '';
      btn123.style.borderColor = this.tempOwnerFormat123 ? '#0f766e' : '';
      btn123.innerHTML = this.tempOwnerFormat123 ? '✓ 1, 2, 3, 4, 5' : '1, 2, 3, 4, 5';
    }
    if (btn100) {
      btn100.style.background = this.tempOwnerFormat100 ? '#0284c7' : '';
      btn100.style.color = this.tempOwnerFormat100 ? '#fff' : '';
      btn100.style.borderColor = this.tempOwnerFormat100 ? '#0284c7' : '';
      btn100.innerHTML = this.tempOwnerFormat100 ? '✓ 101, 102, 103...' : '101, 102, 103...';
    }

    this.renderOwnerRoomsPreview();
  }

  addCustomRoom() {
    const input = document.getElementById('owner-custom-room-name');
    if (!input) return;
    const name = input.value.trim();
    if (!this.tempOwnerRooms) this.tempOwnerRooms = [];
    if (name) {
      if (!this.tempOwnerRooms.includes(name)) {
        this.tempOwnerRooms.push(name);
        input.value = '';
        this.renderOwnerRoomsPreview();
      }
    } else {
      const nextNum = this.tempOwnerRooms.length + 1;
      this.tempOwnerRooms.push(`Room ${nextNum}`);
      this.renderOwnerRoomsPreview();
    }
  }

  removeOwnerRoom(idx) {
    if (!this.tempOwnerRooms || this.tempOwnerRooms.length <= 1) return;
    this.tempOwnerRooms.splice(idx, 1);
    this.renderOwnerRoomsPreview();
  }

  renderOwnerRoomsPreview() {
    const container = document.getElementById('owner-room-chips-container');
    const badge = document.getElementById('owner-room-count-badge');
    if (!container) return;

    if (badge) {
      badge.textContent = `${this.tempOwnerRooms.length} Rooms Total`;
    }

    // Update active state on count buttons
    document.querySelectorAll('.owner-cnt-btn').forEach(btn => {
      const cnt = parseInt(btn.textContent, 10);
      if (cnt === this.tempOwnerRooms.length) {
        btn.style.background = '#0f766e';
        btn.style.color = '#fff';
      } else {
        btn.style.background = '';
        btn.style.color = '';
      }
    });

    container.innerHTML = this.tempOwnerRooms.map((rName, idx) => `
      <div style="display:inline-flex; align-items:center; gap:4px; background:#f0fdfa; border:1px solid #99f6e4; color:#0f766e; padding:3px 8px; border-radius:8px; font-size:0.75rem; font-weight:700;">
        <span>🚪 ${rName}</span>
        ${this.tempOwnerRooms.length > 1 ? `<button type="button" onclick="window.ownerApp.removeOwnerRoom(${idx})" style="background:none; border:none; color:#dc2626; cursor:pointer; font-size:0.75rem; padding:0 2px; font-weight:bold;">✕</button>` : ''}
      </div>
    `).join('');
  }

  addPhotoFromPreset(url, name) {
    if (!this.tempOwnerPhotos) this.tempOwnerPhotos = [];
    if (!this.tempOwnerPhotos.includes(url)) {
      this.tempOwnerPhotos.push(url);
      this.renderOwnerPhotosPreview();
      window.appCoordinator.showToast(`Added ${name} photo`, 'INFO');
    }
  }

  addCustomPhoto() {
    const input = document.getElementById('owner-new-photo-url');
    if (!input) return;
    const url = input.value.trim();
    if (!this.tempOwnerPhotos) this.tempOwnerPhotos = [];
    if (url) {
      this.tempOwnerPhotos.push(url);
      input.value = '';
      this.renderOwnerPhotosPreview();
      window.appCoordinator.showToast('Custom photo added!', 'SUCCESS');
    } else {
      const catalog = [
        'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?auto=format&fit=crop&w=800&q=80',
        'https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?auto=format&fit=crop&w=800&q=80',
        'https://images.unsplash.com/photo-1556911220-e15b29be8c8f?auto=format&fit=crop&w=800&q=80',
        'https://images.unsplash.com/photo-1545324418-cc1a3fa10c00?auto=format&fit=crop&w=800&q=80',
        'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?auto=format&fit=crop&w=800&q=80',
        'https://images.unsplash.com/photo-1584622650111-993a426fbf0a?auto=format&fit=crop&w=800&q=80',
        'https://images.unsplash.com/photo-1617806118233-18e1de247200?auto=format&fit=crop&w=800&q=80',
        'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?auto=format&fit=crop&w=800&q=80'
      ];
      const nextPhoto = catalog.find(p => !this.tempOwnerPhotos.includes(p)) || catalog[Math.floor(Math.random() * catalog.length)];
      this.tempOwnerPhotos.push(nextPhoto);
      this.renderOwnerPhotosPreview();
      window.appCoordinator.showToast('Room photo added!', 'SUCCESS');
    }
  }

  removeOwnerPhoto(idx) {
    if (!this.tempOwnerPhotos) return;
    this.tempOwnerPhotos.splice(idx, 1);
    this.renderOwnerPhotosPreview();
  }

  renderOwnerPhotosPreview() {
    const container = document.getElementById('owner-photo-gallery-preview');
    const badge = document.getElementById('owner-photo-count-badge');
    if (!container) return;

    if (badge) {
      badge.textContent = `${this.tempOwnerPhotos.length} Attached`;
    }

    if (!this.tempOwnerPhotos || this.tempOwnerPhotos.length === 0) {
      container.innerHTML = '<span style="font-size:0.75rem; color:#94a3b8;">No photos attached. Tap presets above to add.</span>';
      return;
    }

    container.innerHTML = this.tempOwnerPhotos.map((url, idx) => `
      <div style="position:relative; flex-shrink:0; width:72px; height:60px; border-radius:8px; overflow:hidden; border:2px solid ${idx === 0 ? '#0f766e' : '#cbd5e1'};">
        <img src="${url}" style="width:100%; height:100%; object-fit:cover;" />
        <span style="position:absolute; top:2px; left:2px; background:${idx === 0 ? '#0f766e' : 'rgba(0,0,0,0.65)'}; color:#fff; font-size:0.6rem; font-weight:700; padding:1px 4px; border-radius:3px;">
          ${idx === 0 ? 'Cover' : '#' + (idx + 1)}
        </span>
        <button type="button" onclick="window.ownerApp.removeOwnerPhoto(${idx})" style="position:absolute; top:2px; right:2px; background:#dc2626; color:#fff; border:none; border-radius:50%; width:16px; height:16px; font-size:10px; cursor:pointer; display:flex; align-items:center; justify-content:center; padding:0;">
          ✕
        </button>
      </div>
    `).join('');
  }

  submitNewProperty(e) {
    e.preventDefault();
    const title = document.getElementById('prop-title').value;
    const propertyType = document.getElementById('prop-type').value;
    const areaType = document.getElementById('prop-area-type').value;
    const city = document.getElementById('prop-city').value;
    const locality = document.getElementById('prop-locality').value;
    const address = document.getElementById('prop-address').value;
    const roomType = document.getElementById('room-type').value;
    const sizeSqFt = document.getElementById('room-size').value;
    const monthlyRent = document.getElementById('room-rent').value;
    const securityDeposit = document.getElementById('room-deposit').value;
    const dueDayOfMonth = document.getElementById('room-due-day').value;
    const electricityInfo = document.getElementById('prop-elec').value;
    const maintenanceInfo = document.getElementById('prop-maint').value;
    
    const photos = (this.tempOwnerPhotos && this.tempOwnerPhotos.length > 0)
      ? this.tempOwnerPhotos
      : ['https://images.unsplash.com/photo-1545324418-cc1a3fa10c00?auto=format&fit=crop&w=800&q=80'];

    const rooms = (this.tempOwnerRooms && this.tempOwnerRooms.length > 0)
      ? this.tempOwnerRooms
      : ['Room 1', 'Room 2', 'Room 3', 'Room 4', 'Room 5'];

    const checkedSuitable = Array.from(document.querySelectorAll('input[name="add-suitable"]:checked')).map(cb => cb.value);

    const extraRooms = rooms.slice(1).map(rName => ({
      roomNumber: rName,
      roomType: roomType,
      sizeSqFt: sizeSqFt,
      monthlyRent: monthlyRent,
      securityDeposit: securityDeposit,
      furnishing: 'Furnished',
      suitableFor: checkedSuitable.length > 0 ? checkedSuitable : ['single', 'working_professional'],
      image: photos[0]
    }));

    this.state.addProperty({
      title,
      propertyType,
      areaType,
      city,
      locality,
      address,
      roomNumber: rooms[0],
      roomType,
      sizeSqFt,
      monthlyRent,
      securityDeposit,
      dueDayOfMonth,
      electricityInfo,
      maintenanceInfo,
      isMultiRoom: rooms.length > 1,
      extraRooms: extraRooms,
      suitableFor: checkedSuitable.length > 0 ? checkedSuitable : ['single', 'working_professional'],
      images: photos,
      gallery: photos,
      image: photos[0]
    });

    this.closeModal('add-property-modal');
    window.appCoordinator.showToast(`Property published with ${rooms.length} rooms (1 to ${rooms.length}) and ${photos.length} photos!`, 'SUCCESS');
    this.switchTab('properties');
  }

  // ===================================================================
  // ADD ROOM TO EXISTING PROPERTY (Section 18)
  // ===================================================================
  openAddRoomModal(propertyId) {
    const prop = this.state.data.properties.find(p => p.id === propertyId);
    if (!prop) return;

    const modalHTML = `
      <div class="modal-backdrop active" id="add-room-modal" onclick="if(event.target===this) window.ownerApp.closeModal('add-room-modal')">
        <div class="modal-card-dialog">
          <div class="modal-header">
            <h3>Add Unit / Room to ${prop.title}</h3>
            <button class="modal-close-btn" onclick="window.ownerApp.closeModal('add-room-modal')">✕</button>
          </div>

          <div class="modal-body">
            <form onsubmit="window.ownerApp.submitNewRoom(event, '${prop.id}')">
              <div class="form-group">
                <label>Room / Unit Number *</label>
                <input type="text" class="form-control" id="new-room-num" value="Room ${prop.rooms.length + 101}" required />
              </div>

              <div style="display:grid; grid-template-columns:1fr 1fr; gap:10px;">
                <div class="form-group">
                  <label>Room Type *</label>
                  <select class="form-control" id="new-room-type">
                    <option value="room">Single Room</option>
                    <option value="1bhk">1 BHK</option>
                    <option value="2bhk">2 BHK</option>
                  </select>
                </div>
                <div class="form-group">
                  <label>Size</label>
                  <input type="text" class="form-control" id="new-room-size" value="400 sq.ft" />
                </div>
              </div>

              <div style="display:grid; grid-template-columns:1fr 1fr; gap:10px;">
                <div class="form-group">
                  <label>Monthly Rent (₹) *</label>
                  <input type="number" class="form-control" id="new-room-rent" value="8000" required />
                </div>
                <div class="form-group">
                  <label>Deposit (₹) *</label>
                  <input type="number" class="form-control" id="new-room-dep" value="16000" required />
                </div>
              </div>

              <button type="submit" class="btn-primary-sm" style="width:100%; padding:12px;">Add Room Unit</button>
            </form>
          </div>
        </div>
      </div>
    `;

    document.body.insertAdjacentHTML('beforeend', modalHTML);
  }

  submitNewRoom(e, propertyId) {
    e.preventDefault();
    const roomNumber = document.getElementById('new-room-num').value;
    const roomType = document.getElementById('new-room-type').value;
    const sizeSqFt = document.getElementById('new-room-size').value;
    const monthlyRent = document.getElementById('new-room-rent').value;
    const securityDeposit = document.getElementById('new-room-dep').value;

    this.state.addRoomToProperty(propertyId, {
      roomNumber,
      roomType,
      sizeSqFt,
      monthlyRent,
      securityDeposit
    });

    this.closeModal('add-room-modal');
    window.appCoordinator.showToast('New room unit added to property!', 'SUCCESS');
    this.switchTab('properties');
  }

  // ===================================================================
  // RECORD PAYMENT RECEIVED MODAL (Section 22)
  // ===================================================================
  openRecordPaymentModal(paymentId) {
    const payment = this.state.data.rentPayments.find(p => p.id === paymentId);
    if (!payment) return;

    const modalHTML = `
      <div class="modal-backdrop active" id="owner-record-pay-modal" onclick="if(event.target===this) window.ownerApp.closeModal('owner-record-pay-modal')">
        <div class="modal-card-dialog">
          <div class="modal-header">
            <h3>Record Rent Collection</h3>
            <button class="modal-close-btn" onclick="window.ownerApp.closeModal('owner-record-pay-modal')">✕</button>
          </div>

          <div class="modal-body">
            <div style="background:#f8fafc; border:1px solid #e2e8f0; border-radius:12px; padding:12px; margin-bottom:14px; font-size:0.82rem;">
              <strong>Rent Month:</strong> ${payment.rentMonth}<br>
              <strong>Amount Due:</strong> ₹${payment.rentAmount.toLocaleString('en-IN')}
            </div>

            <form onsubmit="window.ownerApp.submitOwnerPaymentRecord(event, '${payment.id}')">
              <div class="form-group">
                <label>Received Payment Mode *</label>
                <select class="form-control" id="owner-pay-mode">
                  <option value="Cash">Cash in Hand</option>
                  <option value="UPI">UPI (GPay / PhonePe / Paytm)</option>
                  <option value="Bank Transfer">Bank Transfer (IMPS / NEFT)</option>
                  <option value="Online">Online Portal</option>
                </select>
              </div>

              <div class="form-group">
                <label>Transaction / Counter Receipt Ref</label>
                <input type="text" class="form-control" id="owner-pay-ref" placeholder="e.g. CASH-REC-502 or UPI-992144" value="REC-${Date.now().toString().slice(-6)}" />
              </div>

              <div class="form-group">
                <label>Notes</label>
                <input type="text" class="form-control" id="owner-pay-notes" placeholder="e.g. Received in person on 5th" />
              </div>

              <button type="submit" class="btn-primary-sm" style="width:100%; padding:12px;">Confirm & Generate Receipt</button>
            </form>
          </div>
        </div>
      </div>
    `;

    document.body.insertAdjacentHTML('beforeend', modalHTML);
  }

  submitOwnerPaymentRecord(e, paymentId) {
    e.preventDefault();
    const mode = document.getElementById('owner-pay-mode').value;
    const ref = document.getElementById('owner-pay-ref').value;
    const notes = document.getElementById('owner-pay-notes').value;

    const updated = this.state.recordRentPayment({
      paymentId,
      paymentMode: mode,
      transactionRef: ref,
      notes: notes || `Recorded by Owner on ${new Date().toLocaleDateString()}`,
      paidByOwnerDirect: true
    });

    this.closeModal('owner-record-pay-modal');
    window.appCoordinator.showToast('Rent payment marked as Paid & Receipt Issued!', 'SUCCESS');
    this.switchTab('rent');
  }

  closeModal(id) {
    const el = document.getElementById(id);
    if (el) el.remove();
  }

  attachEventListeners() {}
}

if (typeof window !== 'undefined') {
  window.OwnerAppController = OwnerAppController;
}

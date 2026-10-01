/**
 * Monthly Home, Room, Apartment & Property Rental Platform
 * Master Application Coordinator & Global UI Integrations
 */

class AppCoordinator {
  constructor() {
    this.state = window.appState;
    this.customerApp = new window.CustomerAppController(this.state);
    this.ownerApp = new window.OwnerAppController(this.state);
    this.adminApp = new window.AdminAppController(this.state);

    window.customerApp = this.customerApp;
    window.ownerApp = this.ownerApp;
    window.adminApp = this.adminApp;
    window.appCoordinator = this;

    this.init();
  }

  init() {
    this.initTheme();

    // Subscribe to state mutations
    this.state.subscribe((changeType) => {
      this.renderCurrentView();
      this.updateHeaderControls();
    });

    // Initial render
    this.renderCurrentView();
    this.updateHeaderControls();
    this.setupGlobalEvents();
  }

  renderCurrentView() {
    const mainContainer = document.getElementById('main-app-viewport');
    if (!mainContainer) return;

    if (!this.state.isAuthenticated) {
      this.renderLoginScreen(mainContainer);
      const frameContainer = document.getElementById('device-frame-container');
      if (frameContainer) {
        frameContainer.className = 'device-frame-mobile';
      }
      return;
    }

    const role = this.state.currentRole;

    if (role === 'CUSTOMER') {
      this.customerApp.render(mainContainer);
    } else if (role === 'OWNER') {
      this.ownerApp.render(mainContainer);
    } else if (role === 'ADMIN') {
      this.adminApp.render(mainContainer);
    }

    // Apply view mode class (mobile frame vs wide desktop)
    const frameContainer = document.getElementById('device-frame-container');
    if (frameContainer) {
      if (this.state.viewMode === 'desktop' || role === 'ADMIN') {
        frameContainer.className = 'device-frame-desktop';
      } else {
        frameContainer.className = 'device-frame-mobile';
      }
    }
  }

  setLoginTab(tab) {
    this.loginTab = tab;
    this.renderCurrentView();
  }

  handleLogout() {
    if (confirm('Are you sure you want to log out from this portal and return to the login screen?')) {
      this.state.logout();
    }
  }

  renderLoginScreen(container) {
    const activeTab = this.loginTab || 'CUSTOMER';

    container.innerHTML = `
      <div class="login-portal-screen">
        <div class="login-brand-hero">
          <div class="login-logo-badge">🏠</div>
          <h1 class="login-app-title">RentEase</h1>
          <div class="login-app-tagline">MONTHLY RENTAL PLATFORM</div>
          <p class="login-app-desc">Rooms • Flats • 1/2/3 BHK • Hostels • PGs • Godowns</p>
        </div>

        <div class="login-role-tabs">
          <button class="login-role-btn ${activeTab === 'CUSTOMER' ? 'active' : ''}" onclick="window.appCoordinator.setLoginTab('CUSTOMER')">
            👥 Customer
          </button>
          <button class="login-role-btn ${activeTab === 'OWNER' ? 'active' : ''}" onclick="window.appCoordinator.setLoginTab('OWNER')">
            🏢 Owner
          </button>
          <button class="login-role-btn ${activeTab === 'ADMIN' ? 'active' : ''}" onclick="window.appCoordinator.setLoginTab('ADMIN')">
            🛡️ Admin
          </button>
        </div>

        <div class="login-card-container">
          ${activeTab === 'CUSTOMER' ? this.renderCustomerLoginForm() : ''}
          ${activeTab === 'OWNER' ? this.renderOwnerLoginForm() : ''}
          ${activeTab === 'ADMIN' ? this.renderAdminLoginForm() : ''}
        </div>

        <div class="login-footer-security">
          <span>🔒 Aadhaar e-KYC Verified & 256-bit Encrypted Session</span>
        </div>
      </div>
    `;
  }

  renderCustomerLoginForm() {
    return `
      <div class="login-form-header">
        <div class="login-form-icon" style="background:#ecfdf5; color:#0f766e;">👥</div>
        <div>
          <div class="login-form-title">Customer / Tenant Portal</div>
          <div class="login-form-subtitle">Search rooms, e-KYC agreements & pay rent</div>
        </div>
      </div>

      <div class="login-input-group">
        <label>Mobile Number (+91)</label>
        <input type="tel" id="customer-login-phone" value="9876543210" placeholder="9876543210" />
      </div>

      <div class="login-input-group">
        <label>OTP / Password</label>
        <input type="password" id="customer-login-pass" value="123456" placeholder="123456" />
      </div>

      <button class="btn-login-submit" onclick="window.appCoordinator.state.login('CUSTOMER', 'cust_1')">
        <span>🚀 Login to Customer Panel</span>
      </button>

      <div class="login-divider"><span>OR 1-TAP DEMO LOGIN</span></div>

      <button class="login-demo-btn" onclick="window.appCoordinator.state.login('CUSTOMER', 'cust_1')">
        <div class="login-demo-avatar">⚡</div>
        <div>
          <div class="login-demo-name">Amit Sharma</div>
          <div class="login-demo-role">Working Professional • Varanasi (+91 9876543210)</div>
        </div>
      </button>

      <button class="login-demo-btn" onclick="window.appCoordinator.state.login('CUSTOMER', 'cust_2')">
        <div class="login-demo-avatar">⚡</div>
        <div>
          <div class="login-demo-name">Priya Singh</div>
          <div class="login-demo-role">Student / Bachelor • Lanka (+91 9812345678)</div>
        </div>
      </button>

      <div class="login-features-wrap">
        <span class="login-feature-tag">✓ Search & Filters</span>
        <span class="login-feature-tag">✓ Only Available Units</span>
        <span class="login-feature-tag">✓ Aadhaar e-KYC</span>
        <span class="login-feature-tag">✓ Monthly Rent Receipts</span>
      </div>
    `;
  }

  renderOwnerLoginForm() {
    return `
      <div class="login-form-header">
        <div class="login-form-icon" style="background:#fef3c7; color:#d97706;">🏢</div>
        <div>
          <div class="login-form-title">Property Owner / Landlord Portal</div>
          <div class="login-form-subtitle">Manage units, review requests & collect rent</div>
        </div>
      </div>

      <div class="login-input-group">
        <label>Host Mobile or Email</label>
        <input type="text" id="owner-login-email" value="rajesh.pandey@example.com" placeholder="rajesh.pandey@example.com" />
      </div>

      <div class="login-input-group">
        <label>Host Password</label>
        <input type="password" id="owner-login-pass" value="••••••••" placeholder="••••••••" />
      </div>

      <button class="btn-login-submit" style="background:#d97706;" onclick="window.appCoordinator.state.login('OWNER', 'owner_1')">
        <span>🏢 Login to Owner Panel</span>
      </button>

      <div class="login-divider"><span>OR 1-TAP DEMO LOGIN</span></div>

      <button class="login-demo-btn" onclick="window.appCoordinator.state.login('OWNER', 'owner_1')">
        <div class="login-demo-avatar">⚡</div>
        <div>
          <div class="login-demo-name">Rajesh Pandey</div>
          <div class="login-demo-role">Host of 2 Properties • 3 Units Managed</div>
        </div>
      </button>

      <button class="login-demo-btn" onclick="window.appCoordinator.state.login('OWNER', 'owner_2')">
        <div class="login-demo-avatar">⚡</div>
        <div>
          <div class="login-demo-name">Anil Verma</div>
          <div class="login-demo-role">Host • Godown & Rural Harahua</div>
        </div>
      </button>

      <div class="login-features-wrap">
        <span class="login-feature-tag">✓ 11-KPI Dashboard</span>
        <span class="login-feature-tag">✓ Multi-Unit Control</span>
        <span class="login-feature-tag">✓ Tenant Review</span>
        <span class="login-feature-tag">✓ Rent Recording</span>
      </div>
    `;
  }

  renderAdminLoginForm() {
    return `
      <div class="login-form-header">
        <div class="login-form-icon" style="background:#e0f2fe; color:#0284c7;">🛡️</div>
        <div>
          <div class="login-form-title">Platform Admin Control Center</div>
          <div class="login-form-subtitle">Master governance, approvals & financial audit</div>
        </div>
      </div>

      <div class="login-input-group">
        <label>Admin Email</label>
        <input type="email" id="admin-login-email" value="admin@rentease.com" placeholder="admin@rentease.com" />
      </div>

      <div class="login-input-group">
        <label>Security Passkey</label>
        <input type="password" id="admin-login-pass" value="••••••••" placeholder="••••••••" />
      </div>

      <button class="btn-login-submit" style="background:#0284c7;" onclick="window.appCoordinator.state.login('ADMIN', 'admin_1')">
        <span>🛡️ Access Admin Control Center</span>
      </button>

      <div class="login-divider"><span>OR 1-TAP DEMO LOGIN</span></div>

      <button class="login-demo-btn" onclick="window.appCoordinator.state.login('ADMIN', 'admin_1')">
        <div class="login-demo-avatar">⚡</div>
        <div>
          <div class="login-demo-name">Super Admin</div>
          <div class="login-demo-role">Vikram Malhotra • Full 27-Module Governance</div>
        </div>
      </button>

      <div class="login-features-wrap">
        <span class="login-feature-tag">✓ 27-Module Suite</span>
        <span class="login-feature-tag">✓ Property Approvals</span>
        <span class="login-feature-tag">✓ Full CRUD Records</span>
        <span class="login-feature-tag">✓ Financial Audit Trail</span>
      </div>
    `;
  }

  updateHeaderControls() {
    // Update role buttons
    const roleBtns = document.querySelectorAll('.app-role-switcher .role-tab-btn');
    roleBtns.forEach(btn => {
      const btnRole = btn.getAttribute('data-role');
      if (btnRole === this.state.currentRole) {
        btn.classList.add('active');
      } else {
        btn.classList.remove('active');
      }
    });

    // Update user select options
    const userSelect = document.getElementById('header-user-select');
    if (userSelect) {
      const filteredUsers = this.state.data.users.filter(u => u.role === this.state.currentRole);
      userSelect.innerHTML = filteredUsers.map(u => `
        <option value="${u.id}" ${u.id === this.state.currentUserId ? 'selected' : ''}>
          ${u.avatar || '👤'} ${u.name} (${u.role})
        </option>
      `).join('');
    }

    // Update view toggle label
    const viewToggleBtn = document.getElementById('view-mode-toggle-btn');
    if (viewToggleBtn) {
      viewToggleBtn.innerHTML = this.state.viewMode === 'mobile' ? '📱 Mobile Frame (Active)' : '🖥️ Wide Responsive View';
    }

    // Update unread notification count
    const notifBadge = document.getElementById('header-notif-badge');
    if (notifBadge) {
      const count = this.state.getUnreadNotificationsCount(this.state.currentUserId);
      if (count > 0) {
        notifBadge.style.display = 'flex';
        notifBadge.textContent = count;
      } else {
        notifBadge.style.display = 'none';
      }
    }
  }

  setRole(role) {
    this.state.setRole(role);
  }

  toggleViewMode() {
    const newMode = this.state.viewMode === 'mobile' ? 'desktop' : 'mobile';
    this.state.setViewMode(newMode);
  }

  onUserSelectChange(userId) {
    this.state.setCurrentUser(userId);
  }

  // ===================================================================
  // DIGITAL RENT RECEIPT MODAL (Section 25)
  // ===================================================================
  openDigitalReceipt(paymentId) {
    const payment = this.state.data.rentPayments.find(p => p.id === paymentId);
    if (!payment) return;

    const rental = this.state.data.activeRentals.find(r => r.id === payment.rentalId);
    const tenant = this.state.data.users.find(u => u.id === payment.customerId);
    const owner = this.state.data.users.find(u => u.id === payment.ownerId);
    const propDetails = this.state.getPropertyRoomById(payment.propertyId, payment.roomId);

    const receiptModalHTML = `
      <div class="modal-backdrop active" id="digital-receipt-modal" onclick="if(event.target===this) window.appCoordinator.closeModal('digital-receipt-modal')">
        <div class="modal-card-dialog" style="max-width: 600px;">
          <div class="modal-header">
            <h3>Digital Rent Payment Receipt</h3>
            <div style="display:flex; gap:8px;">
              <button class="btn-primary-sm" style="background:#0284c7; padding:4px 10px; font-size:0.75rem;" onclick="window.print()">
                🖨️ Print / Save PDF
              </button>
              <button class="modal-close-btn" onclick="window.appCoordinator.closeModal('digital-receipt-modal')">✕</button>
            </div>
          </div>

          <div class="modal-body" style="padding:24px;">
            <div class="digital-receipt-sheet">
              <div class="receipt-watermark">PAID</div>

              <!-- Header Row -->
              <div class="receipt-header-row">
                <div>
                  <div class="receipt-brand-logo">🏠 RentEase Platform</div>
                  <div style="font-size:0.72rem; color:#64748b;">Official Tenancy Rent Payment Record</div>
                </div>
                <div class="receipt-meta-right">
                  <div><strong>Receipt No:</strong> ${payment.receiptNumber || 'REC-2026-10-001'}</div>
                  <div><strong>Date Issued:</strong> ${payment.paymentDate || '2026-10-01'}</div>
                  <div><strong>Status:</strong> <span style="color:#059669; font-weight:800;">✓ PAID</span></div>
                </div>
              </div>

              <!-- Details Table (Section 25) -->
              <table class="receipt-details-table">
                <tr>
                  <td class="label-col">Tenant Name:</td>
                  <td class="val-col">${tenant ? tenant.name : 'Tenant'} (📱 +91 ${tenant ? tenant.mobile : 'XXXXX'})</td>
                </tr>
                <tr>
                  <td class="label-col">Property Host / Owner:</td>
                  <td class="val-col">${owner ? owner.name : 'Host'}</td>
                </tr>
                <tr>
                  <td class="label-col">Rented Property & Unit:</td>
                  <td class="val-col">${propDetails ? propDetails.property.title : 'Property'} (${propDetails ? propDetails.room.roomNumber : ''})</td>
                </tr>
                <tr>
                  <td class="label-col">Property Address:</td>
                  <td class="val-col">${propDetails ? propDetails.property.address : 'Address'}</td>
                </tr>
                <tr>
                  <td class="label-col">Rental Period (Month):</td>
                  <td class="val-col"><strong>${payment.rentMonth}</strong></td>
                </tr>
                <tr>
                  <td class="label-col">Payment Mode:</td>
                  <td class="val-col"><strong>${payment.paymentMode || 'Online'}</strong></td>
                </tr>
                <tr>
                  <td class="label-col">Transaction Reference:</td>
                  <td class="val-col" style="font-family:monospace;">${payment.transactionRef || 'TXN-99120482'}</td>
                </tr>
                <tr>
                  <td class="label-col">Payment Notes:</td>
                  <td class="val-col" style="font-style:italic;">"${payment.notes || 'Monthly rent paid in full'}"</td>
                </tr>
              </table>

              <!-- Total Box -->
              <div class="receipt-total-bar">
                <span style="font-weight:700; color:#334155; font-size:0.9rem;">Total Rent Amount Received:</span>
                <span class="total-amount">₹${payment.rentAmount.toLocaleString('en-IN')}</span>
              </div>

              <!-- Verification Seal & QR (Section 25) -->
              <div class="receipt-stamp-seal">
                <div>
                  <span class="digital-seal-badge">✓ UIDAI & Legal Verified</span>
                  <div style="font-size:0.68rem; color:#94a3b8; margin-top:4px;">
                    Digitally signed & audited on RentEase Cloud Ledger
                  </div>
                </div>
                <div style="text-align:right;">
                  <div style="width:48px; height:48px; background:#f1f5f9; border:1px solid #cbd5e1; border-radius:6px; display:inline-flex; align-items:center; justify-content:center; font-size:1.5rem;" title="Encrypted Digital Verification QR">
                    📱
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    `;

    document.body.insertAdjacentHTML('beforeend', receiptModalHTML);
  }

  // ===================================================================
  // GLOBAL NOTIFICATIONS MODAL
  // ===================================================================
  openGlobalNotificationsModal() {
    const notifs = this.state.getNotificationsForUser(this.state.currentUserId);

    const modalHTML = `
      <div class="modal-backdrop active" id="global-notifs-modal" onclick="if(event.target===this) window.appCoordinator.closeModal('global-notifs-modal')">
        <div class="modal-card-dialog">
          <div class="modal-header">
            <h3>🔔 Notification Center</h3>
            <button class="modal-close-btn" onclick="window.appCoordinator.closeModal('global-notifs-modal')">✕</button>
          </div>

          <div class="modal-body">
            <div style="display:flex; flex-direction:column; gap:10px;">
              ${notifs.length === 0 ? `
                <p style="text-align:center; color:#94a3b8; padding:20px;">No notifications at this time.</p>
              ` : notifs.map(n => `
                <div style="background:#f8fafc; border-radius:10px; padding:12px; border-left:4px solid ${n.type.includes('REMINDER') ? '#f59e0b' : '#0f766e'};">
                  <div style="display:flex; justify-content:space-between; font-size:0.75rem; color:#64748b;">
                    <strong>${n.title}</strong>
                    <span>${new Date(n.createdAt).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })}</span>
                  </div>
                  <div style="font-size:0.82rem; color:#1e293b; margin-top:4px;">${n.message}</div>
                </div>
              `).join('')}
            </div>
          </div>
        </div>
      </div>
    `;

    // Mark as read
    notifs.forEach(n => this.state.markNotificationAsRead(n.id));

    document.body.insertAdjacentHTML('beforeend', modalHTML);
  }

  // Toast Notification Dispatcher
  showToast(message, type = 'INFO') {
    let stack = document.getElementById('global-toast-stack');
    if (!stack) {
      stack = document.createElement('div');
      stack.id = 'global-toast-stack';
      stack.className = 'toast-stack';
      document.body.appendChild(stack);
    }

    const toast = document.createElement('div');
    toast.className = 'toast-item';
    if (type === 'SUCCESS') toast.style.borderLeftColor = '#10b981';
    if (type === 'WARNING') toast.style.borderLeftColor = '#f59e0b';
    if (type === 'ERROR') toast.style.borderLeftColor = '#ef4444';

    toast.innerHTML = `
      <span>${type === 'SUCCESS' ? '✅' : (type === 'WARNING' ? '⚠️' : 'ℹ️')}</span>
      <div style="flex:1;">${message}</div>
    `;

    stack.appendChild(toast);

    setTimeout(() => {
      toast.style.opacity = '0';
      toast.style.transform = 'translateY(10px)';
      toast.style.transition = 'all 0.3s ease';
      setTimeout(() => toast.remove(), 300);
    }, 3500);
  }

  closeModal(id) {
    const el = document.getElementById(id);
    if (el) el.remove();
  }

  initTheme() {
    const savedTheme = localStorage.getItem('rentease_theme_mode_v1') || 'light';
    this.applyTheme(savedTheme);
  }

  toggleTheme() {
    const isDark = document.body.getAttribute('data-theme') === 'dark';
    const nextTheme = isDark ? 'light' : 'dark';
    this.applyTheme(nextTheme);
    localStorage.setItem('rentease_theme_mode_v1', nextTheme);
    this.showToast(nextTheme === 'dark' ? 'Switched to Dark Mode 🌙' : 'Switched to Light Mode ☀️', 'INFO');
  }

  applyTheme(theme) {
    const icon = document.getElementById('theme-toggle-icon');
    const text = document.getElementById('theme-toggle-text');
    if (theme === 'dark') {
      document.body.setAttribute('data-theme', 'dark');
      document.body.classList.add('dark-mode');
      if (icon) icon.textContent = '☀️';
      if (text) text.textContent = 'Light';
    } else {
      document.body.removeAttribute('data-theme');
      document.body.classList.remove('dark-mode');
      if (icon) icon.textContent = '🌙';
      if (text) text.textContent = 'Dark';
    }
  }

  setupGlobalEvents() {
    // Keyboard Escape to close modals
    window.addEventListener('keydown', (e) => {
      if (e.key === 'Escape') {
        const activeModal = document.querySelector('.modal-backdrop.active');
        if (activeModal) activeModal.remove();
      }
    });
  }
}

// Start application when DOM is ready
document.addEventListener('DOMContentLoaded', () => {
  new AppCoordinator();
});

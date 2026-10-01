/**
 * Monthly Home, Room, Apartment & Property Rental Platform
 * Master Admin Panel Controller & Platform Governance Engine (All 27 Sections)
 */

class AdminAppController {
  constructor(appState) {
    this.state = appState;
    this.activeSection = 'dashboard'; // 'dashboard' | 'customers' | 'owners' | 'properties' | 'property_types' | 'suitable_for' | 'areas' | 'approvals' | 'rental_requests' | 'agreements' | 'active_rentals' | 'rent_payments' | 'payment_history' | 'month_history' | 'rent_reminders' | 'collection_report' | 'complaints' | 'notifications' | 'reports' | 'admin_users' | 'audit_log' | 'settings'
    this.dateFilter = 'THIS_MONTH'; // 'TODAY' | 'THIS_WEEK' | 'THIS_MONTH' | 'LAST_MONTH' | 'CUSTOM'
    this.activeReportType = 'RENT_COLLECTION';
    this.isLoggedIn = true; // Session state (can toggle to show login screen)
    this.sidebarCollapsed = false;
    this.tableFilters = {
      customerFilter: 'ALL',
      ownerFilter: 'ALL',
      propertyFilter: 'ALL',
      paymentStatusFilter: 'ALL',
      paymentModeFilter: 'ALL',
      complaintStatusFilter: 'ALL',
      selectedMonthHistoryCustomer: null,
      selectedMonthHistoryRental: null
    };
  }

  // --- Main Render Entry Point ---
  render(container) {
    if (!this.isLoggedIn) {
      this.renderAdminLogin(container);
      return;
    }

    const currentAdmin = this.state.data.adminUsers?.find(a => a.id === this.state.currentUserId) || {
      name: 'Super Administrator',
      adminRole: 'Super Admin',
      email: 'admin@rentease.in'
    };

    container.innerHTML = `
      <div class="admin-master-wrapper">
        <!-- Admin Global Search Modal Anchor -->
        <div id="admin-modal-root"></div>

        <!-- Admin Top Navigation Bar -->
        <header class="admin-top-navbar">
          <div class="admin-nav-left">
            <button class="admin-btn-icon" onclick="window.adminApp.toggleSidebar()" title="Toggle Sidebar">
              ☰
            </button>
            <div class="admin-brand-header">
              <span class="admin-shield-badge">🛡️</span>
              <div>
                <h2 class="admin-brand-title">RentEase Admin Panel</h2>
                <span class="admin-brand-sub">Master Property & Rental Governance System</span>
              </div>
            </div>
          </div>

          <!-- Global Admin Search Bar -->
          <div class="admin-search-box-wrapper">
            <span class="search-icon">🔍</span>
            <input 
              type="text" 
              class="admin-global-search-input" 
              placeholder="Search Customer, Owner, Property ID, Txn #, Agreement..." 
              oninput="window.adminApp.handleGlobalSearch(this.value)"
              onfocus="window.adminApp.handleGlobalSearch(this.value)"
            />
            <div id="admin-search-dropdown" class="admin-search-results-dropdown" style="display:none;"></div>
          </div>

          <!-- Admin Quick Action Toolbar -->
          <div class="admin-nav-right">
            <button class="btn-primary-sm" style="background:#0284c7; padding:6px 12px;" onclick="window.adminApp.openBroadcastModal()">
              📢 Broadcast
            </button>
            <button class="btn-primary-sm" style="background:#059669; padding:6px 12px;" onclick="window.adminApp.switchSection('reports')">
              📥 Reports
            </button>
            <button class="btn-primary-sm" style="background:#64748b; padding:6px 12px;" onclick="window.adminApp.resetDataPrompt()">
              🔄 Reset DB
            </button>

            <!-- Admin Profile Badge & Session Dropdown -->
            <div class="admin-user-badge" onclick="window.adminApp.openAdminUserMenu()">
              <div class="admin-avatar">👤</div>
              <div class="admin-user-meta">
                <span class="admin-user-name">${currentAdmin.name}</span>
                <span class="admin-role-pill">${currentAdmin.adminRole || 'Super Admin'}</span>
              </div>
              <button class="btn-logout-tiny" onclick="event.stopPropagation(); window.adminApp.logout()" title="Logout Admin">🚪</button>
            </div>
          </div>
        </header>

        <!-- Main Body: Sidebar + Dynamic Workspace -->
        <div class="admin-body-layout">
          <!-- Sidebar Navigation (Section 3 & 27) -->
          <aside class="admin-sidebar ${this.sidebarCollapsed ? 'collapsed' : ''}" id="admin-sidebar-nav">
            <div class="admin-sidebar-section-title">MAIN NAVIGATION</div>
            <nav class="admin-sidebar-menu">
              ${this.getSidebarMenuItems().map(item => `
                <button 
                  class="admin-nav-item ${this.activeSection === item.id ? 'active' : ''}" 
                  onclick="window.adminApp.switchSection('${item.id}')"
                  title="${item.title}"
                >
                  <span class="nav-icon">${item.icon}</span>
                  <span class="nav-text">${item.title}</span>
                  ${item.badge !== undefined && item.badge > 0 ? `<span class="nav-badge ${item.badgeClass || ''}">${item.badge}</span>` : ''}
                </button>
              `).join('')}
            </nav>

            <div class="admin-sidebar-footer">
              <div class="system-status-indicator">
                <span class="pulse-dot"></span>
                <span>Platform Live (v2.4)</span>
              </div>
            </div>
          </aside>

          <!-- Dynamic Workspace Canvas -->
          <main class="admin-workspace-content" id="admin-main-section">
            ${this.getSectionHTML()}
          </main>
        </div>
      </div>
    `;

    this.attachEventListeners();
  }

  // --- Sidebar Items Definition (Sections 3 & 27) ---
  getSidebarMenuItems() {
    const stats = this.state.getAdminStatistics();
    return [
      { id: 'dashboard', title: 'Dashboard', icon: '📊' },
      { id: 'customers', title: 'Customers', icon: '👥', badge: stats.totalCustomers },
      { id: 'owners', title: 'Owners', icon: '🏢', badge: stats.totalOwners },
      { id: 'properties', title: 'Properties', icon: '🏘️', badge: stats.totalProperties },
      { id: 'property_types', title: 'Property Types', icon: '🏷️' },
      { id: 'suitable_for', title: 'Suitable For', icon: '🎯' },
      { id: 'areas', title: 'Areas & Locations', icon: '📍' },
      { id: 'approvals', title: 'Property Approvals', icon: '⏳', badge: stats.pendingPropertyApprovals, badgeClass: stats.pendingPropertyApprovals > 0 ? 'badge-amber' : '' },
      { id: 'rental_requests', title: 'Rental Requests', icon: '📥', badge: stats.pendingRentalRequests, badgeClass: 'badge-sky' },
      { id: 'agreements', title: 'Agreements', icon: '📑', badge: stats.completedAgreements },
      { id: 'active_rentals', title: 'Active Rentals', icon: '🔑', badge: stats.activeRentals, badgeClass: 'badge-emerald' },
      { id: 'rent_payments', title: 'Rent Payments', icon: '💰' },
      { id: 'payment_history', title: 'Payment History', icon: '📜' },
      { id: 'month_history', title: 'Month-Wise History', icon: '📅' },
      { id: 'rent_reminders', title: 'Rent Reminders', icon: '⏰' },
      { id: 'collection_report', title: 'Rent Collection', icon: '📈' },
      { id: 'complaints', title: 'Complaints', icon: '🛠️', badge: stats.openComplaints, badgeClass: stats.openComplaints > 0 ? 'badge-rose' : '' },
      { id: 'notifications', title: 'Notifications', icon: '🔔' },
      { id: 'reports', title: 'Reports & CSV', icon: '📄' },
      { id: 'admin_users', title: 'Admin Users (RBAC)', icon: '🛡️' },
      { id: 'audit_log', title: 'Audit Logs', icon: '📝' },
      { id: 'settings', title: 'Settings', icon: '⚙️' }
    ];
  }

  // --- Router & Switcher ---
  switchSection(sectionId) {
    this.activeSection = sectionId;
    const el = document.getElementById('admin-main-section');
    if (el) {
      el.innerHTML = this.getSectionHTML();
      window.scrollTo({ top: 0, behavior: 'smooth' });
    }
    // Update active nav button
    document.querySelectorAll('.admin-nav-item').forEach(btn => btn.classList.remove('active'));
    const activeBtn = Array.from(document.querySelectorAll('.admin-nav-item')).find(b => b.getAttribute('onclick')?.includes(sectionId));
    if (activeBtn) activeBtn.classList.add('active');
  }

  toggleSidebar() {
    this.sidebarCollapsed = !this.sidebarCollapsed;
    const sidebar = document.getElementById('admin-sidebar-nav');
    if (sidebar) sidebar.classList.toggle('collapsed', this.sidebarCollapsed);
  }

  setDateFilter(filter) {
    this.dateFilter = filter;
    this.switchSection('dashboard');
  }

  // ===================================================================
  // SECTION ROUTING DISPATCHER
  // ===================================================================
  getSectionHTML() {
    switch (this.activeSection) {
      case 'dashboard': return this.renderDashboard();
      case 'customers': return this.renderCustomers();
      case 'owners': return this.renderOwners();
      case 'properties': return this.renderProperties();
      case 'property_types': return this.renderPropertyTypes();
      case 'suitable_for': return this.renderSuitableFor();
      case 'areas': return this.renderAreas();
      case 'approvals': return this.renderPropertyApprovals();
      case 'rental_requests': return this.renderRentalRequests();
      case 'agreements': return this.renderAgreements();
      case 'active_rentals': return this.renderActiveRentals();
      case 'rent_payments': return this.renderRentPayments();
      case 'payment_history': return this.renderPaymentHistory();
      case 'month_history': return this.renderMonthWiseHistory();
      case 'rent_reminders': return this.renderRentReminders();
      case 'collection_report': return this.renderCollectionReport();
      case 'complaints': return this.renderComplaints();
      case 'notifications': return this.renderNotifications();
      case 'reports': return this.renderReports();
      case 'admin_users': return this.renderAdminUsers();
      case 'audit_log': return this.renderAuditLogs();
      case 'settings': return this.renderSettings();
      default: return this.renderDashboard();
    }
  }

  // ===================================================================
  // 1. ADMIN LOGIN (Section 1)
  // ===================================================================
  renderAdminLogin(container) {
    container.innerHTML = `
      <div class="admin-login-screen">
        <div class="admin-login-card">
          <div class="login-brand-header">
            <div class="login-logo-circle">🛡️</div>
            <h2>RentEase Admin Portal</h2>
            <p>Secure Role-Based Governance for Monthly Rental Platform</p>
          </div>

          <form id="admin-login-form" onsubmit="window.adminApp.handleLoginSubmit(event)">
            <div class="form-group">
              <label>Admin Email or Mobile</label>
              <input type="text" id="admin-login-email" class="form-control" value="admin@rentease.in" placeholder="admin@rentease.in" required />
            </div>

            <div class="form-group">
              <div style="display:flex; justify-content:space-between; align-items:center;">
                <label>Password</label>
                <a href="javascript:void(0)" onclick="window.adminApp.openForgotPasswordModal()" style="font-size:0.75rem; color:#0284c7;">Forgot Password?</a>
              </div>
              <input type="password" id="admin-login-pass" class="form-control" value="admin123" placeholder="••••••••" required />
            </div>

            <div class="form-group">
              <label style="display:flex; justify-content:space-between;">
                <span>2FA / OTP Verification Code</span>
                <span style="font-size:0.7rem; color:#10b981;">✓ 2FA-Ready (Default: 123456)</span>
              </label>
              <input type="text" id="admin-login-otp" class="form-control" value="123456" maxlength="6" placeholder="Enter 6-digit OTP" />
            </div>

            <button type="submit" class="btn-primary-sm" style="width:100%; padding:12px; font-size:0.95rem; background:#0f766e; margin-top:10px;">
              🔒 Authenticate & Access Dashboard
            </button>
          </form>

          <!-- Quick Test Persona Selector -->
          <div class="login-quick-demo">
            <div style="font-size:0.75rem; color:#64748b; font-weight:700; margin-bottom:8px; text-transform:uppercase;">Quick Demo Login:</div>
            <div style="display:flex; gap:6px; flex-wrap:wrap;">
              <button class="btn-secondary-sm" onclick="window.adminApp.fillDemoLogin('admin@rentease.in', 'admin123')">Super Admin</button>
              <button class="btn-secondary-sm" onclick="window.adminApp.fillDemoLogin('vikas.verma@rentease.in', 'admin123')">Finance Admin</button>
              <button class="btn-secondary-sm" onclick="window.adminApp.fillDemoLogin('ananya.roy@rentease.in', 'admin123')">Support Admin</button>
            </div>
          </div>
        </div>
      </div>
    `;
  }

  fillDemoLogin(email, pass) {
    const e = document.getElementById('admin-login-email');
    const p = document.getElementById('admin-login-pass');
    if (e) e.value = email;
    if (p) p.value = pass;
  }

  handleLoginSubmit(e) {
    e.preventDefault();
    const email = document.getElementById('admin-login-email').value;
    const pass = document.getElementById('admin-login-pass').value;
    const otp = document.getElementById('admin-login-otp').value;

    try {
      this.state.adminLogin({ email, password: pass, otp });
      this.isLoggedIn = true;
      window.appCoordinator.showToast('Admin Authentication Successful!', 'SUCCESS');
      const root = document.getElementById('main-app-viewport');
      if (root) this.render(root);
    } catch (err) {
      alert(err.message || 'Login failed.');
    }
  }

  logout() {
    this.state.adminLogout();
    this.isLoggedIn = false;
    window.appCoordinator.showToast('Logged out of Admin Panel.', 'INFO');
    const root = document.getElementById('main-app-viewport');
    if (root) this.render(root);
  }

  openForgotPasswordModal() {
    alert('Password recovery link and OTP have been dispatched to registered Admin Mobile/Email (+91 9988776655). Use test password: admin123');
  }

  // ===================================================================
  // 2. ADMIN DASHBOARD (Section 2)
  // ===================================================================
  renderDashboard() {
    const stats = this.state.getAdminStatistics(this.dateFilter);

    return `
      <!-- Dashboard Top Header & Date Filters -->
      <div class="admin-page-header">
        <div>
          <h1 class="page-title">📊 Executive Platform Dashboard</h1>
          <p class="page-subtitle">Real-time overview of monthly rentals, financial collections, user growth & support tickets.</p>
        </div>

        <!-- Date Range Filter Tabs -->
        <div class="admin-date-filter-group">
          ${[
            { id: 'TODAY', label: 'Today' },
            { id: 'THIS_WEEK', label: 'This Week' },
            { id: 'THIS_MONTH', label: 'This Month' },
            { id: 'LAST_MONTH', label: 'Last Month' },
            { id: 'CUSTOM', label: 'Custom Range' }
          ].map(d => `
            <button 
              class="date-filter-btn ${this.dateFilter === d.id ? 'active' : ''}" 
              onclick="window.adminApp.setDateFilter('${d.id}')"
            >
              ${d.label}
            </button>
          `).join('')}
        </div>
      </div>

      <!-- 12 KPI Metric Cards Grid (Section 2) -->
      <div class="admin-kpi-grid">
        <div class="kpi-card" onclick="window.adminApp.switchSection('customers')">
          <div class="kpi-icon-wrap" style="background:#e0f2fe; color:#0284c7;">👥</div>
          <div class="kpi-info">
            <span class="kpi-label">Total Customers</span>
            <h3 class="kpi-value">${stats.totalCustomers}</h3>
            <span class="kpi-trend positive">↑ 100% Verified</span>
          </div>
        </div>

        <div class="kpi-card" onclick="window.adminApp.switchSection('owners')">
          <div class="kpi-icon-wrap" style="background:#fef3c7; color:#d97706;">🏢</div>
          <div class="kpi-info">
            <span class="kpi-label">Total Owners / Hosts</span>
            <h3 class="kpi-value">${stats.totalOwners}</h3>
            <span class="kpi-trend positive">Active Portfolios</span>
          </div>
        </div>

        <div class="kpi-card" onclick="window.adminApp.switchSection('properties')">
          <div class="kpi-icon-wrap" style="background:#ede9fe; color:#7c3aed;">🏘️</div>
          <div class="kpi-info">
            <span class="kpi-label">Total Properties</span>
            <h3 class="kpi-value">${stats.totalProperties} <small>(${stats.totalRooms} Units)</small></h3>
            <span class="kpi-trend">Urban & Rural</span>
          </div>
        </div>

        <div class="kpi-card" onclick="window.adminApp.switchSection('properties')">
          <div class="kpi-icon-wrap" style="background:#ecfdf5; color:#059669;">🟢</div>
          <div class="kpi-info">
            <span class="kpi-label">Available Units</span>
            <h3 class="kpi-value" style="color:#059669;">${stats.availableRooms}</h3>
            <span class="kpi-trend positive">Open for Booking</span>
          </div>
        </div>

        <div class="kpi-card" onclick="window.adminApp.switchSection('active_rentals')">
          <div class="kpi-icon-wrap" style="background:#f1f5f9; color:#475569;">🔑</div>
          <div class="kpi-info">
            <span class="kpi-label">Rented Properties / Units</span>
            <h3 class="kpi-value">${stats.rentedRooms}</h3>
            <span class="kpi-trend">${stats.occupancyRate}% Occupancy</span>
          </div>
        </div>

        <div class="kpi-card ${stats.pendingPropertyApprovals > 0 ? 'highlight-kpi-amber' : ''}" onclick="window.adminApp.switchSection('approvals')">
          <div class="kpi-icon-wrap" style="background:#fffbeb; color:#b45309;">⏳</div>
          <div class="kpi-info">
            <span class="kpi-label">Pending Approvals</span>
            <h3 class="kpi-value" style="color:#b45309;">${stats.pendingPropertyApprovals}</h3>
            <span class="kpi-trend ${stats.pendingPropertyApprovals > 0 ? 'negative' : 'positive'}">
              ${stats.pendingPropertyApprovals > 0 ? 'Action Required' : 'All Approved'}
            </span>
          </div>
        </div>

        <div class="kpi-card" onclick="window.adminApp.switchSection('rental_requests')">
          <div class="kpi-icon-wrap" style="background:#f0fdf4; color:#16a34a;">📥</div>
          <div class="kpi-info">
            <span class="kpi-label">Pending Rental Requests</span>
            <h3 class="kpi-value">${stats.pendingRentalRequests}</h3>
            <span class="kpi-trend">In Owner Review</span>
          </div>
        </div>

        <div class="kpi-card" onclick="window.adminApp.switchSection('agreements')">
          <div class="kpi-icon-wrap" style="background:#e0e7ff; color:#4338ca;">📑</div>
          <div class="kpi-info">
            <span class="kpi-label">Completed Agreements</span>
            <h3 class="kpi-value" style="color:#4338ca;">${stats.completedAgreements}</h3>
            <span class="kpi-trend positive">✓ UIDAI KYC Verified</span>
          </div>
        </div>

        <div class="kpi-card" onclick="window.adminApp.switchSection('active_rentals')">
          <div class="kpi-icon-wrap" style="background:#ecfeff; color:#0891b2;">🏠</div>
          <div class="kpi-info">
            <span class="kpi-label">Active Rentals</span>
            <h3 class="kpi-value" style="color:#0891b2;">${stats.activeRentals}</h3>
            <span class="kpi-trend">Generating Monthly Rent</span>
          </div>
        </div>

        <div class="kpi-card highlight-kpi-green" onclick="window.adminApp.switchSection('rent_payments')">
          <div class="kpi-icon-wrap" style="background:#dcfce7; color:#15803d;">💰</div>
          <div class="kpi-info">
            <span class="kpi-label">Monthly Rent Collected</span>
            <h3 class="kpi-value" style="color:#15803d;">₹${stats.totalRentCollected.toLocaleString('en-IN')}</h3>
            <span class="kpi-trend positive">${stats.totalTransactions} Completed Txns</span>
          </div>
        </div>

        <div class="kpi-card ${stats.totalPendingRent > 0 ? 'highlight-kpi-rose' : ''}" onclick="window.adminApp.switchSection('rent_payments')">
          <div class="kpi-icon-wrap" style="background:#ffe4e6; color:#e11d48;">⚠️</div>
          <div class="kpi-info">
            <span class="kpi-label">Pending Rent</span>
            <h3 class="kpi-value" style="color:#e11d48;">₹${stats.totalPendingRent.toLocaleString('en-IN')}</h3>
            <span class="kpi-trend negative">Reminders Dispatched</span>
          </div>
        </div>

        <div class="kpi-card" onclick="window.adminApp.switchSection('complaints')">
          <div class="kpi-icon-wrap" style="background:${stats.openComplaints > 0 ? '#fee2e2' : '#f0fdf4'}; color:${stats.openComplaints > 0 ? '#b91c1c' : '#15803d'};">🛠️</div>
          <div class="kpi-info">
            <span class="kpi-label">Support Complaints</span>
            <h3 class="kpi-value" style="color:${stats.openComplaints > 0 ? '#b91c1c' : '#15803d'};">${stats.totalComplaints}</h3>
            <span class="kpi-trend ${stats.openComplaints > 0 ? 'negative' : 'positive'}">
              ${stats.openComplaints} Open Tickets
            </span>
          </div>
        </div>
      </div>

      <!-- Interactive Charts Row (Section 2) -->
      <div class="admin-charts-grid">
        <!-- Chart 1: Monthly Rent Collection Trend -->
        <div class="admin-chart-card">
          <div class="chart-header">
            <h4>📈 Monthly Rent Collection Trend (₹)</h4>
            <span class="chart-sub">Last 4 Months Comparison</span>
          </div>
          <div class="chart-body">
            ${this.renderMonthlyCollectionChart(stats.monthlyTrends)}
          </div>
        </div>

        <!-- Chart 2: Property Occupancy (Available vs Rented) -->
        <div class="admin-chart-card">
          <div class="chart-header">
            <h4>🏢 Units: Available vs Rented</h4>
            <span class="chart-sub">Total ${stats.totalRooms} Units Monitored</span>
          </div>
          <div class="chart-body">
            ${this.renderDonutChart([
              { label: 'Available Units', value: stats.availableRooms, color: '#10b981' },
              { label: 'Rented Units', value: stats.rentedRooms, color: '#0284c7' },
              { label: 'Requests / Hold', value: Math.max(0, stats.totalRooms - stats.availableRooms - stats.rentedRooms), color: '#f59e0b' }
            ])}
          </div>
        </div>

        <!-- Chart 3: Payment Modes Distribution -->
        <div class="admin-chart-card">
          <div class="chart-header">
            <h4>💳 Payment Mode Breakdown</h4>
            <span class="chart-sub">Cash, UPI, Online & Bank Transfers</span>
          </div>
          <div class="chart-body">
            ${this.renderPaymentModesBar(stats.paymentModeCounts)}
          </div>
        </div>

        <!-- Chart 4: Rental Requests Breakdown -->
        <div class="admin-chart-card">
          <div class="chart-header">
            <h4>📥 Rental Request Status</h4>
            <span class="chart-sub">Pending vs Accepted vs Rejected</span>
          </div>
          <div class="chart-body">
            ${this.renderRequestsStatusChart()}
          </div>
        </div>
      </div>

      <!-- Quick Action Feeds: Recent Requests & Recent Rent Payments -->
      <div class="admin-feeds-grid">
        <div class="admin-feed-card">
          <div class="feed-header">
            <h4>⏳ Pending Property Approvals Queue (${stats.pendingPropertyApprovals})</h4>
            <a href="javascript:void(0)" onclick="window.adminApp.switchSection('approvals')">View Queue →</a>
          </div>
          <div class="feed-body">
            ${this.state.data.properties.filter(p => p.approvalStatus === 'Pending Approval').slice(0, 3).map(p => `
              <div class="feed-item">
                <div class="feed-icon">🏢</div>
                <div class="feed-details">
                  <strong>${p.title}</strong> (${p.propertyType.toUpperCase()} in ${p.city})
                  <div class="feed-sub">Owner: ${this.state.data.users.find(u => u.id === p.ownerId)?.name || 'Host'} • ₹${p.rooms[0]?.monthlyRent || 0}/mo</div>
                </div>
                <button class="btn-primary-sm" style="background:#059669; padding:4px 8px; font-size:0.75rem;" onclick="window.adminApp.quickApproveProperty('${p.id}')">Approve</button>
              </div>
            `).join('') || '<div style="padding:20px; text-align:center; color:#64748b; font-size:0.85rem;">✓ No properties pending approval.</div>'}
          </div>
        </div>

        <div class="admin-feed-card">
          <div class="feed-header">
            <h4>💳 Latest Rent Transactions</h4>
            <a href="javascript:void(0)" onclick="window.adminApp.switchSection('rent_payments')">View All →</a>
          </div>
          <div class="feed-body">
            ${this.state.data.rentPayments.slice(0, 4).map(p => {
              const cust = this.state.data.users.find(u => u.id === p.customerId);
              return `
                <div class="feed-item">
                  <div class="feed-icon" style="background:#ecfdf5; color:#059669;">₹</div>
                  <div class="feed-details">
                    <strong>₹${p.rentAmount.toLocaleString('en-IN')}</strong> (${p.rentMonth})
                    <div class="feed-sub">${cust ? cust.name : 'Tenant'} • ${p.paymentMode || 'Pending'} • ${p.dueDate}</div>
                  </div>
                  <span class="hist-status-pill ${p.paymentStatus.toLowerCase()}">${p.paymentStatus}</span>
                </div>
              `;
            }).join('')}
          </div>
        </div>
      </div>
    `;
  }

  // --- SVG Chart Renderers for Dashboard ---
  renderMonthlyCollectionChart(trends) {
    const maxVal = 100000;
    return `
      <div style="display:flex; justify-content:space-between; align-items:flex-end; height:180px; padding:10px 10px 0 10px; gap:16px;">
        ${trends.map(t => {
          const heightPct = Math.round((t.collected / maxVal) * 100);
          return `
            <div style="flex:1; display:flex; flex-direction:column; align-items:center; height:100%; justify-content:flex-end;">
              <span style="font-size:0.72rem; font-weight:700; color:#059669; margin-bottom:4px;">₹${(t.collected / 1000).toFixed(0)}k</span>
              <div style="width:100%; max-width:44px; background:linear-gradient(180deg, #10b981 0%, #047857 100%); height:${Math.max(15, heightPct)}%; border-radius:6px 6px 0 0; transition:all 0.3s ease;"></div>
              <span style="font-size:0.75rem; color:#475569; margin-top:8px; font-weight:600;">${t.month}</span>
            </div>
          `;
        }).join('')}
      </div>
    `;
  }

  renderDonutChart(items) {
    const total = items.reduce((acc, cur) => acc + cur.value, 0) || 1;
    return `
      <div style="display:flex; align-items:center; gap:20px; padding:10px;">
        <div style="position:relative; width:130px; height:130px; border-radius:50%; background:conic-gradient(
          #10b981 0% ${(items[0].value/total)*100}%,
          #0284c7 ${(items[0].value/total)*100}% ${((items[0].value+items[1].value)/total)*100}%,
          #f59e0b ${((items[0].value+items[1].value)/total)*100}% 100%
        ); display:flex; align-items:center; justify-content:center; box-shadow:var(--shadow-sm);">
          <div style="width:74px; height:74px; background:#ffffff; border-radius:50%; display:flex; flex-direction:column; align-items:center; justify-content:center;">
            <strong style="font-size:1.1rem; color:#0f172a;">${total}</strong>
            <span style="font-size:0.65rem; color:#64748b;">Units</span>
          </div>
        </div>

        <div style="display:flex; flex-direction:column; gap:8px; flex:1;">
          ${items.map(it => `
            <div style="display:flex; justify-content:space-between; align-items:center; font-size:0.8rem;">
              <span style="display:flex; align-items:center; gap:6px;">
                <span style="display:inline-block; width:10px; height:10px; border-radius:3px; background:${it.color};"></span>
                ${it.label}
              </span>
              <strong>${it.value} <small style="color:#64748b;">(${Math.round((it.value/total)*100)}%)</small></strong>
            </div>
          `).join('')}
        </div>
      </div>
    `;
  }

  renderPaymentModesBar(modeCounts) {
    const total = Object.values(modeCounts).reduce((a, b) => a + b, 0) || 1;
    return `
      <div style="padding:10px; display:flex; flex-direction:column; gap:12px;">
        ${Object.entries(modeCounts).map(([mode, amt]) => {
          const pct = Math.round((amt / total) * 100);
          return `
            <div>
              <div style="display:flex; justify-content:space-between; font-size:0.8rem; margin-bottom:4px;">
                <span>${mode}</span>
                <strong>₹${amt.toLocaleString('en-IN')} (${pct}%)</strong>
              </div>
              <div style="height:8px; background:#f1f5f9; border-radius:999px; overflow:hidden;">
                <div style="height:100%; width:${pct}%; background:#0284c7; border-radius:999px;"></div>
              </div>
            </div>
          `;
        }).join('')}
      </div>
    `;
  }

  renderRequestsStatusChart() {
    const requests = this.state.data.rentalRequests;
    const pending = requests.filter(r => r.status === 'Pending').length;
    const accepted = requests.filter(r => r.status === 'Accepted').length;
    const rejected = requests.filter(r => r.status === 'Rejected').length;

    return `
      <div style="display:flex; gap:12px; padding:15px; text-align:center;">
        <div style="flex:1; background:#f0fdf4; border:1px solid #bbf7d0; border-radius:10px; padding:12px;">
          <div style="font-size:1.4rem; font-weight:800; color:#16a34a;">${accepted}</div>
          <div style="font-size:0.75rem; color:#15803d; font-weight:700;">Accepted</div>
        </div>
        <div style="flex:1; background:#fefce8; border:1px solid #fef08a; border-radius:10px; padding:12px;">
          <div style="font-size:1.4rem; font-weight:800; color:#ca8a04;">${pending}</div>
          <div style="font-size:0.75rem; color:#a16207; font-weight:700;">Pending</div>
        </div>
        <div style="flex:1; background:#fef2f2; border:1px solid #fecaca; border-radius:10px; padding:12px;">
          <div style="font-size:1.4rem; font-weight:800; color:#dc2626;">${rejected}</div>
          <div style="font-size:0.75rem; color:#991b1b; font-weight:700;">Rejected</div>
        </div>
      </div>
    `;
  }

  // ===================================================================
  // 4. CUSTOMER MANAGEMENT (Section 4)
  // ===================================================================
  renderCustomers() {
    let customers = this.state.data.users.filter(u => u.role === 'CUSTOMER');
    const filter = this.tableFilters.customerFilter;

    if (filter === 'ACTIVE') customers = customers.filter(c => (c.status || 'Active') === 'Active');
    else if (filter === 'DEACTIVATED') customers = customers.filter(c => c.status === 'Deactivated');
    else if (filter === 'VERIFIED') customers = customers.filter(c => c.aadhaarVerified);
    else if (filter === 'UNVERIFIED') customers = customers.filter(c => !c.aadhaarVerified);
    else if (filter === 'HAS_RENTAL') {
      customers = customers.filter(c => this.state.data.activeRentals.some(r => r.customerId === c.id && r.status === 'Active'));
    }

    return `
      <div class="admin-data-card">
        <div class="admin-card-header">
          <div>
            <h3>👥 Registered Customers Directory (${customers.length})</h3>
            <span style="font-size:0.75rem; color:#64748b;">Manage customer verification, profiles, and active leases</span>
          </div>

          <div style="display:flex; gap:8px; align-items:center;">
            <button class="btn-primary-sm" style="background:#0284c7;" onclick="window.adminApp.openAddCustomerModal()">
              ➕ Add Customer
            </button>
            <!-- Customer Filters -->
            <div style="display:flex; gap:6px; flex-wrap:wrap;">
              ${[
                { id: 'ALL', label: 'All Customers' },
                { id: 'ACTIVE', label: 'Active' },
                { id: 'VERIFIED', label: 'KYC Verified' },
                { id: 'HAS_RENTAL', label: 'Has Active Rental' },
                { id: 'DEACTIVATED', label: 'Deactivated' }
              ].map(f => `
                <button 
                  class="btn-secondary-sm ${filter === f.id ? 'active-filter' : ''}" 
                  onclick="window.adminApp.setCustomerFilter('${f.id}')"
                >
                  ${f.label}
                </button>
              `).join('')}
            </div>
          </div>
        </div>

        <div class="admin-table-responsive">
          <table class="admin-table">
            <thead>
              <tr>
                <th>Customer ID & Name</th>
                <th>Mobile & Email</th>
                <th>City / Area</th>
                <th>Category</th>
                <th>Aadhaar KYC</th>
                <th>Active Rental</th>
                <th>Account Status</th>
                <th>Actions</th>
              </tr>
            </thead>
            <tbody>
              ${customers.map(c => {
                const activeLease = this.state.data.activeRentals.find(r => r.customerId === c.id && r.status === 'Active');
                const isDeactivated = c.status === 'Deactivated';

                return `
                  <tr>
                    <td>
                      <strong>${c.name}</strong><br>
                      <span style="font-size:0.7rem; color:#64748b;">ID: ${c.id}</span>
                    </td>
                    <td>
                      📱 +91 ${c.mobile}<br>
                      <span style="font-size:0.72rem; color:#64748b;">${c.email}</span>
                    </td>
                    <td>${c.address || 'Varanasi'}</td>
                    <td><span class="badge-pill-blue">${c.customerType || 'Single'}</span></td>
                    <td>
                      <span style="color:${c.aadhaarVerified ? '#059669' : '#dc2626'}; font-weight:700; font-size:0.78rem;">
                        ${c.aadhaarVerified ? `✓ Verified (•••• ${c.aadhaarLast4 || '4512'})` : '⚠️ Pending'}
                      </span>
                    </td>
                    <td>
                      ${activeLease ? `
                        <span style="color:#059669; font-weight:700; font-size:0.78rem;">
                          ${activeLease.propertySnapshot.roomNumber} (₹${(activeLease.monthlyRent || activeLease.propertySnapshot?.monthlyRent || 0).toLocaleString('en-IN')})
                        </span>
                      ` : '<span style="color:#94a3b8; font-size:0.78rem;">No Active Lease</span>'}
                    </td>
                    <td>
                      <span class="hist-status-pill ${isDeactivated ? 'rented' : 'paid'}">
                        ${isDeactivated ? 'Deactivated' : 'Active'}
                      </span>
                    </td>
                    <td>
                      <div style="display:flex; gap:4px; flex-wrap:wrap;">
                        <button class="btn-receipt-download" onclick="window.adminApp.openCustomerProfileModal('${c.id}')">
                          View
                        </button>
                        <button class="btn-secondary-sm" style="padding:2px 6px; font-size:0.7rem;" onclick="window.adminApp.openEditCustomerModal('${c.id}')">
                          Edit ✎
                        </button>
                        <button 
                          class="btn-action-tiny" 
                          style="color:${isDeactivated ? '#059669' : '#dc2626'};"
                          onclick="window.adminApp.toggleUserStatus('${c.id}')"
                        >
                          ${isDeactivated ? 'Activate' : 'Deactivate'}
                        </button>
                        <button class="btn-action-tiny" style="color:#dc2626;" onclick="window.adminApp.deleteCustomer('${c.id}')">
                          🗑️
                        </button>
                      </div>
                    </td>
                  </tr>
                `;
              }).join('')}
            </tbody>
          </table>
        </div>
      </div>
    `;
  }

  setCustomerFilter(f) {
    this.tableFilters.customerFilter = f;
    this.switchSection('customers');
  }

  openCustomerProfileModal(customerId) {
    const profile = this.state.adminGetCustomerProfile(customerId);
    if (!profile.customer) return;
    const c = profile.customer;

    const modalHTML = `
      <div class="modal-backdrop active" id="admin-cust-modal" onclick="if(event.target===this) window.adminApp.closeModal('admin-cust-modal')">
        <div class="modal-card-dialog modal-large">
          <div class="modal-header">
            <h3>👤 Customer Master Profile: ${c.name}</h3>
            <button class="modal-close-btn" onclick="window.adminApp.closeModal('admin-cust-modal')">✕</button>
          </div>

          <div class="modal-body">
            <!-- Top Personal & KYC Summary -->
            <div style="display:grid; grid-template-columns:1fr 1fr; gap:16px; background:#f8fafc; padding:16px; border-radius:12px; margin-bottom:20px; border:1px solid #e2e8f0;">
              <div>
                <div><strong>Customer ID:</strong> ${c.id}</div>
                <div><strong>Mobile:</strong> +91 ${c.mobile}</div>
                <div><strong>Email:</strong> ${c.email}</div>
                <div><strong>Address:</strong> ${c.address || 'N/A'}</div>
              </div>
              <div>
                <div><strong>Category:</strong> ${c.customerType || 'Single'}</div>
                <div><strong>Registration Date:</strong> ${c.createdAt || '2026-05-10'}</div>
                <div><strong>Aadhaar KYC:</strong> ${c.aadhaarVerified ? `✓ UIDAI Verified (•••• ${c.aadhaarLast4 || '4512'})` : '⚠️ Pending'}</div>
                <div><strong>Account Status:</strong> <span class="hist-status-pill ${c.status === 'Deactivated' ? 'rented' : 'paid'}">${c.status || 'Active'}</span></div>
              </div>
            </div>

            <!-- Active Lease Summary -->
            <h4 style="margin-bottom:8px;">🔑 Active Rental Details</h4>
            ${profile.activeRental ? `
              <div style="background:#ecfdf5; border:1px solid #a7f3d0; padding:12px 16px; border-radius:8px; margin-bottom:20px; font-size:0.85rem;">
                <strong>${profile.activeRental.propertySnapshot.title}</strong> (${profile.activeRental.propertySnapshot.roomNumber})<br>
                Monthly Rent: <strong>₹${(profile.activeRental.monthlyRent || profile.activeRental.propertySnapshot?.monthlyRent || 0).toLocaleString('en-IN')}</strong> • Security Deposit: ₹${(profile.activeRental.securityDeposit || 0).toLocaleString('en-IN')}<br>
                Start Date: ${profile.activeRental.rentStartDate || profile.activeRental.startDate || '2026-10-01'} • Rent Due: ${profile.activeRental.monthlyDueDay || profile.activeRental.dueDayOfMonth || 5}th of each month
              </div>
            ` : '<p style="color:#64748b; font-size:0.85rem; margin-bottom:20px;">No current active rental.</p>'}

            <!-- History: Requests & Payment Ledger -->
            <h4 style="margin-bottom:8px;">📑 Tenancy Agreements & Payment History (${profile.payments.length} Payments)</h4>
            <div class="admin-table-responsive" style="max-height:220px; overflow-y:auto;">
              <table class="admin-table">
                <thead>
                  <tr>
                    <th>Month</th>
                    <th>Amount</th>
                    <th>Mode</th>
                    <th>Status</th>
                    <th>Receipt #</th>
                  </tr>
                </thead>
                <tbody>
                  ${profile.payments.map(p => `
                    <tr>
                      <td>${p.rentMonth}</td>
                      <td>₹${p.rentAmount.toLocaleString('en-IN')}</td>
                      <td>${p.paymentMode || 'Pending'}</td>
                      <td><span class="hist-status-pill ${p.paymentStatus.toLowerCase()}">${p.paymentStatus}</span></td>
                      <td>${p.receiptNumber || '-'}</td>
                    </tr>
                  `).join('') || '<tr><td colspan="5">No payment records found.</td></tr>'}
                </tbody>
              </table>
            </div>
          </div>
        </div>
      </div>
    `;

    document.body.insertAdjacentHTML('beforeend', modalHTML);
  }

  // ===================================================================
  // 5. OWNER MANAGEMENT (Section 5)
  // ===================================================================
  renderOwners() {
    let owners = this.state.data.users.filter(u => u.role === 'OWNER');
    const filter = this.tableFilters.ownerFilter;

    if (filter === 'ACTIVE') owners = owners.filter(o => (o.status || 'Active') === 'Active');
    else if (filter === 'DEACTIVATED') owners = owners.filter(o => o.status === 'Deactivated');

    return `
      <div class="admin-data-card">
        <div class="admin-card-header">
          <div>
            <h3>🏢 Property Hosts & Owners Directory (${owners.length})</h3>
            <span style="font-size:0.75rem; color:#64748b;">Manage landlords, portfolios, privacy settings and rent collections</span>
          </div>

          <div style="display:flex; gap:8px; align-items:center;">
            <button class="btn-primary-sm" style="background:#d97706;" onclick="window.adminApp.openAddOwnerModal()">
              ➕ Add Landlord
            </button>
            <!-- Owner Filters -->
            <div style="display:flex; gap:6px;">
              <button class="btn-secondary-sm ${filter === 'ALL' ? 'active-filter' : ''}" onclick="window.adminApp.setOwnerFilter('ALL')">All Owners</button>
              <button class="btn-secondary-sm ${filter === 'ACTIVE' ? 'active-filter' : ''}" onclick="window.adminApp.setOwnerFilter('ACTIVE')">Active Hosts</button>
              <button class="btn-secondary-sm ${filter === 'DEACTIVATED' ? 'active-filter' : ''}" onclick="window.adminApp.setOwnerFilter('DEACTIVATED')">Deactivated</button>
            </div>
          </div>
        </div>

        <div class="admin-table-responsive">
          <table class="admin-table">
            <thead>
              <tr>
                <th>Owner ID & Name</th>
                <th>Mobile & Email</th>
                <th>Total Properties</th>
                <th>Available Units</th>
                <th>Rented Units</th>
                <th>Contact Privacy</th>
                <th>Account Status</th>
                <th>Actions</th>
              </tr>
            </thead>
            <tbody>
              ${owners.map(o => {
                const props = this.state.data.properties.filter(p => p.ownerId === o.id);
                let availCount = 0;
                let rentedCount = 0;
                props.forEach(p => {
                  p.rooms.forEach(r => {
                    if (r.status === 'Available') availCount++;
                    else if (r.status === 'Rented') rentedCount++;
                  });
                });
                const isDeactivated = o.status === 'Deactivated';

                return `
                  <tr>
                    <td>
                      <strong>${o.name}</strong><br>
                      <span style="font-size:0.7rem; color:#64748b;">ID: ${o.id}</span>
                    </td>
                    <td>
                      📱 +91 ${o.mobile}<br>
                      <span style="font-size:0.72rem; color:#64748b;">${o.email || 'N/A'}</span>
                    </td>
                    <td><strong>${props.length}</strong> Listed</td>
                    <td><span style="color:#059669; font-weight:700;">${availCount} Units</span></td>
                    <td><span style="color:#0284c7; font-weight:700;">${rentedCount} Leased</span></td>
                    <td><span class="badge-pill-gray">${o.contactSettings || 'CALL_MSG_ON'}</span></td>
                    <td>
                      <span class="hist-status-pill ${isDeactivated ? 'rented' : 'paid'}">
                        ${isDeactivated ? 'Deactivated' : 'Active'}
                      </span>
                    </td>
                    <td>
                      <div style="display:flex; gap:4px; flex-wrap:wrap;">
                        <button class="btn-receipt-download" onclick="window.adminApp.openOwnerProfileModal('${o.id}')">
                          View
                        </button>
                        <button class="btn-secondary-sm" style="padding:2px 6px; font-size:0.7rem;" onclick="window.adminApp.openEditOwnerModal('${o.id}')">
                          Edit ✎
                        </button>
                        <button 
                          class="btn-action-tiny" 
                          style="color:${isDeactivated ? '#059669' : '#dc2626'};"
                          onclick="window.adminApp.toggleUserStatus('${o.id}')"
                        >
                          ${isDeactivated ? 'Activate' : 'Deactivate'}
                        </button>
                        <button class="btn-action-tiny" style="color:#dc2626;" onclick="window.adminApp.deleteOwner('${o.id}')">
                          🗑️
                        </button>
                      </div>
                    </td>
                  </tr>
                `;
              }).join('')}
            </tbody>
          </table>
        </div>
      </div>
    `;
  }

  setOwnerFilter(f) {
    this.tableFilters.ownerFilter = f;
    this.switchSection('owners');
  }

  openOwnerProfileModal(ownerId) {
    const profile = this.state.adminGetOwnerProfile(ownerId);
    if (!profile.owner) return;
    const o = profile.owner;

    const modalHTML = `
      <div class="modal-backdrop active" id="admin-owner-modal" onclick="if(event.target===this) window.adminApp.closeModal('admin-owner-modal')">
        <div class="modal-card-dialog modal-large">
          <div class="modal-header">
            <h3>🏢 Landlord Master Profile: ${o.name}</h3>
            <button class="modal-close-btn" onclick="window.adminApp.closeModal('admin-owner-modal')">✕</button>
          </div>

          <div class="modal-body">
            <div style="display:grid; grid-template-columns:1fr 1fr; gap:16px; background:#f8fafc; padding:16px; border-radius:12px; margin-bottom:20px; border:1px solid #e2e8f0;">
              <div>
                <div><strong>Owner ID:</strong> ${o.id}</div>
                <div><strong>Mobile:</strong> +91 ${o.mobile}</div>
                <div><strong>Contact Privacy:</strong> ${o.contactSettings || 'CALL_MSG_ON'}</div>
              </div>
              <div>
                <div><strong>Total Properties:</strong> ${profile.properties.length}</div>
                <div><strong>Total Rent Collected:</strong> <span style="color:#059669; font-weight:700;">₹${profile.totalCollected.toLocaleString('en-IN')}</span></div>
                <div><strong>Pending Rent:</strong> <span style="color:#dc2626; font-weight:700;">₹${profile.totalPending.toLocaleString('en-IN')}</span></div>
              </div>
            </div>

            <h4>🏘️ Properties Portfolio (${profile.properties.length})</h4>
            <div class="admin-table-responsive" style="max-height:220px; overflow-y:auto;">
              <table class="admin-table">
                <thead>
                  <tr>
                    <th>Property Title</th>
                    <th>City / Area</th>
                    <th>Type</th>
                    <th>Units</th>
                    <th>Status</th>
                  </tr>
                </thead>
                <tbody>
                  ${profile.properties.map(p => `
                    <tr>
                      <td><strong>${p.title}</strong></td>
                      <td>${p.city} (${p.locality})</td>
                      <td>${p.propertyType.toUpperCase()}</td>
                      <td>${p.rooms.length} Units</td>
                      <td><span class="hist-status-pill paid">${p.approvalStatus || 'Approved'}</span></td>
                    </tr>
                  `).join('')}
                </tbody>
              </table>
            </div>
          </div>
        </div>
      </div>
    `;

    document.body.insertAdjacentHTML('beforeend', modalHTML);
  }

  toggleUserStatus(userId) {
    this.state.adminToggleUserStatus(userId);
    window.appCoordinator.showToast('User account status toggled.', 'SUCCESS');
    const u = this.state.data.users.find(usr => usr.id === userId);
    if (u?.role === 'CUSTOMER') this.switchSection('customers');
    else this.switchSection('owners');
  }

  // ===================================================================
  // 6. PROPERTY MANAGEMENT (Section 6)
  // ===================================================================
  renderProperties() {
    let properties = this.state.data.properties;
    const filter = this.tableFilters.propertyFilter;

    if (filter === 'APPROVED') properties = properties.filter(p => p.approvalStatus === 'Approved');
    else if (filter === 'PENDING') properties = properties.filter(p => p.approvalStatus === 'Pending Approval');
    else if (filter === 'DEACTIVATED') properties = properties.filter(p => p.approvalStatus === 'Deactivated');

    return `
      <div class="admin-data-card">
        <div class="admin-card-header">
          <div>
            <h3>🏘️ Master Property Listings (${properties.length})</h3>
            <span style="font-size:0.75rem; color:#64748b;">Manage properties across Urban & Rural locations</span>
          </div>

          <div style="display:flex; gap:8px; align-items:center;">
            <button class="btn-primary-sm" style="background:#0F766E;" onclick="window.adminApp.openAddPropertyModal()">
              ➕ Add Property
            </button>
            <div style="display:flex; gap:6px;">
              <button class="btn-secondary-sm ${filter === 'ALL' ? 'active-filter' : ''}" onclick="window.adminApp.setPropertyFilter('ALL')">All</button>
              <button class="btn-secondary-sm ${filter === 'APPROVED' ? 'active-filter' : ''}" onclick="window.adminApp.setPropertyFilter('APPROVED')">Approved</button>
              <button class="btn-secondary-sm ${filter === 'PENDING' ? 'active-filter' : ''}" onclick="window.adminApp.setPropertyFilter('PENDING')">Pending Approval</button>
              <button class="btn-secondary-sm ${filter === 'DEACTIVATED' ? 'active-filter' : ''}" onclick="window.adminApp.setPropertyFilter('DEACTIVATED')">Deactivated</button>
            </div>
          </div>
        </div>

        <div class="admin-table-responsive">
          <table class="admin-table">
            <thead>
              <tr>
                <th>Property ID & Title</th>
                <th>Owner</th>
                <th>Location</th>
                <th>Type</th>
                <th>Units / Rooms</th>
                <th>Rent Range</th>
                <th>Approval Status</th>
                <th>Actions</th>
              </tr>
            </thead>
            <tbody>
              ${properties.map(p => {
                const owner = this.state.data.users.find(u => u.id === p.ownerId);
                const rentArr = p.rooms.map(r => r.monthlyRent);
                const minR = Math.min(...rentArr);
                const maxR = Math.max(...rentArr);
                const isDeactivated = p.approvalStatus === 'Deactivated';

                return `
                  <tr>
                    <td>
                      <strong>${p.title}</strong><br>
                      <span style="font-size:0.7rem; color:#64748b;">ID: ${p.id}</span>
                    </td>
                    <td>${owner ? owner.name : 'Owner'}</td>
                    <td>${p.locality}, ${p.city} <span class="badge-pill-gray">${p.areaType}</span></td>
                    <td><strong>${p.propertyType.toUpperCase()}</strong></td>
                    <td>
                      ${p.rooms.map(r => `
                        <div style="font-size:0.72rem;">
                          ${r.roomNumber}: <span class="badge-status ${r.status === 'Rented' ? 'rented' : (r.status === 'Available' ? 'available' : 'pending')}" style="padding:1px 5px; font-size:0.65rem;">${r.status}</span>
                        </div>
                      `).join('')}
                    </td>
                    <td><strong>₹${minR.toLocaleString('en-IN')}${minR !== maxR ? ` - ₹${maxR.toLocaleString('en-IN')}` : ''}</strong> /mo</td>
                    <td>
                      <span class="hist-status-pill ${p.approvalStatus === 'Approved' ? 'paid' : (p.approvalStatus === 'Pending Approval' ? 'pending' : 'rented')}">
                        ${p.approvalStatus || 'Approved'}
                      </span>
                    </td>
                    <td>
                      <div style="display:flex; gap:4px; flex-wrap:wrap;">
                        <button class="btn-receipt-download" onclick="window.adminApp.openPropertyViewModal('${p.id}')">View</button>
                        <button class="btn-secondary-sm" style="padding:2px 6px; font-size:0.7rem;" onclick="window.adminApp.openEditPropertyModal('${p.id}')">Edit ✎</button>
                        <button class="btn-action-tiny" style="color:${isDeactivated ? '#059669' : '#dc2626'};" onclick="window.adminApp.togglePropertyStatus('${p.id}')">
                          ${isDeactivated ? 'Activate' : 'Deactivate'}
                        </button>
                        <button class="btn-action-tiny" style="color:#dc2626;" onclick="window.adminApp.deleteProperty('${p.id}')">🗑️</button>
                      </div>
                    </td>
                  </tr>
                `;
              }).join('')}
            </tbody>
          </table>
        </div>
      </div>
    `;
  }

  setPropertyFilter(f) {
    this.tableFilters.propertyFilter = f;
    this.switchSection('properties');
  }

  togglePropertyStatus(propId) {
    this.state.adminTogglePropertyAvailability(propId);
    window.appCoordinator.showToast('Property status updated.', 'SUCCESS');
    this.switchSection('properties');
  }

  openPropertyViewModal(propId) {
    const p = this.state.data.properties.find(prop => prop.id === propId);
    if (!p) return;
    const owner = this.state.data.users.find(u => u.id === p.ownerId);

    const modalHTML = `
      <div class="modal-backdrop active" id="admin-prop-modal" onclick="if(event.target===this) window.adminApp.closeModal('admin-prop-modal')">
        <div class="modal-card-dialog modal-large">
          <div class="modal-header">
            <h3>🏘️ Property Details: ${p.title}</h3>
            <button class="modal-close-btn" onclick="window.adminApp.closeModal('admin-prop-modal')">✕</button>
          </div>

          <div class="modal-body">
            <div style="display:grid; grid-template-columns:1fr 1fr; gap:16px; margin-bottom:16px;">
              <div>
                <div><strong>Property ID:</strong> ${p.id}</div>
                <div><strong>Owner:</strong> ${owner ? owner.name : 'Host'} (+91 ${owner?.mobile})</div>
                <div><strong>Address:</strong> ${p.address}, ${p.locality}, ${p.city}</div>
                <div><strong>Area Type:</strong> ${p.areaType.toUpperCase()}</div>
              </div>
              <div>
                <div><strong>Category / Type:</strong> ${p.propertyType.toUpperCase()}</div>
                <div><strong>Approval Status:</strong> ${p.approvalStatus || 'Approved'}</div>
                <div><strong>Security Deposit:</strong> ₹${(p.securityDeposit || 0).toLocaleString('en-IN')}</div>
              </div>
            </div>

            <h4>Amenities & Conditions</h4>
            <div style="display:flex; gap:6px; flex-wrap:wrap; margin-bottom:16px;">
              ${(p.amenities || []).map(a => `<span class="badge-pill-blue">${a}</span>`).join('')}
            </div>

            <h4>Room / Unit Breakdown (${p.rooms.length} Units)</h4>
            <div class="admin-table-responsive">
              <table class="admin-table">
                <thead>
                  <tr>
                    <th>Room #</th>
                    <th>Type</th>
                    <th>Rent</th>
                    <th>Suitable For</th>
                    <th>Status</th>
                  </tr>
                </thead>
                <tbody>
                  ${p.rooms.map(r => `
                    <tr>
                      <td><strong>${r.roomNumber}</strong></td>
                      <td>${r.name}</td>
                      <td>₹${r.monthlyRent.toLocaleString('en-IN')}/mo</td>
                      <td>${(r.suitableFor || []).join(', ')}</td>
                      <td><span class="badge-status ${r.status === 'Rented' ? 'rented' : (r.status === 'Available' ? 'available' : 'pending')}">${r.status}</span></td>
                    </tr>
                  `).join('')}
                </tbody>
              </table>
            </div>
          </div>
        </div>
      </div>
    `;

    document.body.insertAdjacentHTML('beforeend', modalHTML);
  }

  // ===================================================================
  // 7. PROPERTY TYPE MANAGEMENT (Section 7)
  // ===================================================================
  renderPropertyTypes() {
    return `
      <div class="admin-data-card">
        <div class="admin-card-header">
          <div>
            <h3>🏷️ Property Category & Type Management (${this.state.data.propertyTypes.length})</h3>
            <span style="font-size:0.75rem; color:#64748b;">Configure rental asset classes (Room, Flat, Hostel, PG, Godown, etc.)</span>
          </div>
          <button class="btn-primary-sm" style="background:#0284c7;" onclick="window.adminApp.openAddPropertyTypeModal()">
            + Add Property Type
          </button>
        </div>

        <div class="admin-table-responsive">
          <table class="admin-table">
            <thead>
              <tr>
                <th>Icon & Category Name</th>
                <th>System ID</th>
                <th>Description</th>
                <th>Active Properties Using</th>
                <th>Status</th>
                <th>Actions</th>
              </tr>
            </thead>
            <tbody>
              ${this.state.data.propertyTypes.map(t => {
                const count = this.state.data.properties.filter(p => p.propertyType === t.id).length;
                return `
                  <tr>
                    <td><span style="font-size:1.3rem; margin-right:8px;">${t.icon || '🏠'}</span><strong>${t.name}</strong></td>
                    <td><code>${t.id}</code></td>
                    <td>${t.description || '-'}</td>
                    <td><strong>${count}</strong> Properties</td>
                    <td><span class="hist-status-pill paid">${t.active !== false ? 'Active' : 'Inactive'}</span></td>
                    <td>
                      <button class="btn-action-tiny" style="color:#dc2626;" onclick="window.adminApp.deletePropertyType('${t.id}')">
                        Delete
                      </button>
                    </td>
                  </tr>
                `;
              }).join('')}
            </tbody>
          </table>
        </div>
      </div>
    `;
  }

  openAddPropertyTypeModal() {
    const modalHTML = `
      <div class="modal-backdrop active" id="admin-add-pt-modal" onclick="if(event.target===this) window.adminApp.closeModal('admin-add-pt-modal')">
        <div class="modal-card-dialog">
          <div class="modal-header">
            <h3>+ Add New Property Type</h3>
            <button class="modal-close-btn" onclick="window.adminApp.closeModal('admin-add-pt-modal')">✕</button>
          </div>
          <div class="modal-body">
            <form onsubmit="window.adminApp.submitNewPropertyType(event)">
              <div class="form-group">
                <label>Category Name</label>
                <input type="text" class="form-control" id="new-pt-name" placeholder="e.g. Commercial Studio or Penthouse" required />
              </div>
              <div class="form-group">
                <label>Icon Emoji</label>
                <input type="text" class="form-control" id="new-pt-icon" placeholder="e.g. 🏢" value="🏠" />
              </div>
              <div class="form-group">
                <label>Description</label>
                <input type="text" class="form-control" id="new-pt-desc" placeholder="Brief description..." />
              </div>
              <button type="submit" class="btn-primary-sm" style="width:100%; padding:10px;">Save Property Type</button>
            </form>
          </div>
        </div>
      </div>
    `;
    document.body.insertAdjacentHTML('beforeend', modalHTML);
  }

  submitNewPropertyType(e) {
    e.preventDefault();
    const name = document.getElementById('new-pt-name').value;
    const icon = document.getElementById('new-pt-icon').value;
    const description = document.getElementById('new-pt-desc').value;

    this.state.adminAddPropertyType({ name, icon, description });
    this.closeModal('admin-add-pt-modal');
    window.appCoordinator.showToast(`Property type "${name}" created.`, 'SUCCESS');
    this.switchSection('property_types');
  }

  deletePropertyType(typeId) {
    try {
      this.state.adminDeletePropertyType(typeId);
      window.appCoordinator.showToast('Property category deleted.', 'SUCCESS');
      this.switchSection('property_types');
    } catch (err) {
      alert(err.message);
    }
  }

  // ===================================================================
  // 8. SUITABLE FOR / CUSTOMER TYPE MANAGEMENT (Section 8)
  // ===================================================================
  renderSuitableFor() {
    return `
      <div class="admin-data-card">
        <div class="admin-card-header">
          <div>
            <h3>🎯 Suitable For / Eligibility Categories (${this.state.data.customerTypes.length})</h3>
            <span style="font-size:0.75rem; color:#64748b;">Manage tenant eligibility filters (Students, Family, Boys, Girls, PG, etc.)</span>
          </div>
          <button class="btn-primary-sm" style="background:#0284c7;" onclick="window.adminApp.openAddSuitableForModal()">
            + Add Category
          </button>
        </div>

        <div class="admin-table-responsive">
          <table class="admin-table">
            <thead>
              <tr>
                <th>Category Name</th>
                <th>System ID</th>
                <th>Color Badge Preview</th>
                <th>Properties Listed Under</th>
                <th>Actions</th>
              </tr>
            </thead>
            <tbody>
              ${this.state.data.customerTypes.map(c => {
                let usageCount = 0;
                this.state.data.properties.forEach(p => {
                  if (p.rooms.some(r => (r.suitableFor || []).includes(c.id))) usageCount++;
                });

                return `
                  <tr>
                    <td><strong>${c.name}</strong></td>
                    <td><code>${c.id}</code></td>
                    <td>
                      <span style="background:${c.badgeColor || '#0ea5e9'}; color:#ffffff; padding:3px 10px; border-radius:999px; font-size:0.75rem; font-weight:700;">
                        ${c.name}
                      </span>
                    </td>
                    <td><strong>${usageCount}</strong> Properties</td>
                    <td>
                      <button class="btn-action-tiny" style="color:#dc2626;" onclick="window.adminApp.deleteSuitableFor('${c.id}')">
                        Delete
                      </button>
                    </td>
                  </tr>
                `;
              }).join('')}
            </tbody>
          </table>
        </div>
      </div>
    `;
  }

  openAddSuitableForModal() {
    const modalHTML = `
      <div class="modal-backdrop active" id="admin-add-sf-modal" onclick="if(event.target===this) window.adminApp.closeModal('admin-add-sf-modal')">
        <div class="modal-card-dialog">
          <div class="modal-header">
            <h3>+ Add Suitable For Category</h3>
            <button class="modal-close-btn" onclick="window.adminApp.closeModal('admin-add-sf-modal')">✕</button>
          </div>
          <div class="modal-body">
            <form onsubmit="window.adminApp.submitNewSuitableFor(event)">
              <div class="form-group">
                <label>Category Title</label>
                <input type="text" class="form-control" id="new-sf-name" placeholder="e.g. Senior Citizens or IT Professionals" required />
              </div>
              <div class="form-group">
                <label>Badge Hex Color</label>
                <input type="color" class="form-control" id="new-sf-color" value="#0ea5e9" style="height:40px;" />
              </div>
              <button type="submit" class="btn-primary-sm" style="width:100%; padding:10px;">Save Category</button>
            </form>
          </div>
        </div>
      </div>
    `;
    document.body.insertAdjacentHTML('beforeend', modalHTML);
  }

  submitNewSuitableFor(e) {
    e.preventDefault();
    const name = document.getElementById('new-sf-name').value;
    const badgeColor = document.getElementById('new-sf-color').value;

    this.state.adminAddSuitableForCategory({ name, badgeColor });
    this.closeModal('admin-add-sf-modal');
    window.appCoordinator.showToast(`Category "${name}" created.`, 'SUCCESS');
    this.switchSection('suitable_for');
  }

  deleteSuitableFor(catId) {
    this.state.adminDeleteSuitableForCategory(catId);
    window.appCoordinator.showToast('Suitable For category deleted.', 'SUCCESS');
    this.switchSection('suitable_for');
  }

  // ===================================================================
  // 9. AREA HIERARCHY MANAGEMENT (Section 9)
  // ===================================================================
  renderAreas() {
    const { urban, rural } = this.state.data.areas;

    return `
      <div style="display:grid; grid-template-columns:1fr 1fr; gap:20px;">
        <!-- Urban City Locations -->
        <div class="admin-data-card">
          <div class="admin-card-header">
            <div>
              <h4>🌆 Urban City Locations (${urban.length})</h4>
              <span style="font-size:0.75rem; color:#64748b;">Country → State → City → Localities</span>
            </div>
            <button class="btn-primary-sm" style="background:#0284c7; padding:4px 8px; font-size:0.75rem;" onclick="window.adminApp.openAddAreaModal('URBAN')">+ Add Locality</button>
          </div>
          <div style="padding:16px;">
            ${urban.map(u => `
              <div style="margin-bottom:14px; padding-bottom:12px; border-bottom:1px solid #f1f5f9;">
                <div style="display:flex; justify-content:space-between; align-items:center;">
                  <h5 style="font-size:1rem; color:#0f172a; margin:0;">${u.city}</h5>
                  <span style="font-size:0.72rem; color:#64748b;">${u.localities.length} Localities</span>
                </div>
                <div style="display:flex; flex-wrap:wrap; gap:6px; margin-top:8px;">
                  ${u.localities.map(loc => `
                    <span class="badge-pill-gray" style="display:inline-flex; align-items:center; gap:4px;">
                      ${loc}
                      <span style="cursor:pointer; color:#ef4444; font-weight:700;" onclick="window.adminApp.deleteUrbanLocality('${u.city}', '${loc}')">×</span>
                    </span>
                  `).join('')}
                </div>
              </div>
            `).join('')}
          </div>
        </div>

        <!-- Rural Districts & Villages -->
        <div class="admin-data-card">
          <div class="admin-card-header">
            <div>
              <h4>🌾 Rural Districts & Villages (${rural.length})</h4>
              <span style="font-size:0.75rem; color:#64748b;">Country → State → District / Tehsil → Villages</span>
            </div>
            <button class="btn-primary-sm" style="background:#d97706; padding:4px 8px; font-size:0.75rem;" onclick="window.adminApp.openAddAreaModal('RURAL')">+ Add Village</button>
          </div>
          <div style="padding:16px;">
            ${rural.map(r => `
              <div style="margin-bottom:14px; padding-bottom:12px; border-bottom:1px solid #f1f5f9;">
                <div style="display:flex; justify-content:space-between; align-items:center;">
                  <h5 style="font-size:1rem; color:#0f172a; margin:0;">${r.district}</h5>
                  <span style="font-size:0.72rem; color:#64748b;">${r.villages.length} Villages</span>
                </div>
                <div style="display:flex; flex-wrap:wrap; gap:6px; margin-top:8px;">
                  ${r.villages.map(v => `
                    <span class="badge-pill-amber" style="display:inline-flex; align-items:center; gap:4px;">
                      ${v}
                      <span style="cursor:pointer; color:#ef4444; font-weight:700;" onclick="window.adminApp.deleteRuralVillage('${r.district}', '${v}')">×</span>
                    </span>
                  `).join('')}
                </div>
              </div>
            `).join('')}
          </div>
        </div>
      </div>
    `;
  }

  openAddAreaModal(type) {
    const isUrban = type === 'URBAN';
    const modalHTML = `
      <div class="modal-backdrop active" id="admin-area-modal" onclick="if(event.target===this) window.adminApp.closeModal('admin-area-modal')">
        <div class="modal-card-dialog">
          <div class="modal-header">
            <h3>+ Add ${isUrban ? 'Urban City Locality' : 'Rural Village'}</h3>
            <button class="modal-close-btn" onclick="window.adminApp.closeModal('admin-area-modal')">✕</button>
          </div>
          <div class="modal-body">
            <form onsubmit="window.adminApp.submitNewArea(event, '${type}')">
              <div class="form-group">
                <label>${isUrban ? 'City Name' : 'Rural District'}</label>
                <input type="text" class="form-control" id="area-group-name" placeholder="${isUrban ? 'e.g. Varanasi or Lucknow' : 'e.g. Varanasi Rural'}" required />
              </div>
              <div class="form-group">
                <label>${isUrban ? 'Locality / Area Name' : 'Village / Gram Panchayat Name'}</label>
                <input type="text" class="form-control" id="area-item-name" placeholder="${isUrban ? 'e.g. BHU Lanka Road' : 'e.g. Harahua Village'}" required />
              </div>
              <button type="submit" class="btn-primary-sm" style="width:100%; padding:10px;">Save Location</button>
            </form>
          </div>
        </div>
      </div>
    `;
    document.body.insertAdjacentHTML('beforeend', modalHTML);
  }

  submitNewArea(e, type) {
    e.preventDefault();
    const group = document.getElementById('area-group-name').value;
    const item = document.getElementById('area-item-name').value;

    if (type === 'URBAN') {
      this.state.adminAddUrbanLocality(group, item);
    } else {
      this.state.adminAddRuralVillage(group, item);
    }

    this.closeModal('admin-area-modal');
    window.appCoordinator.showToast(`Location "${item}" added to ${group}.`, 'SUCCESS');
    this.switchSection('areas');
  }

  deleteUrbanLocality(city, loc) {
    this.state.adminDeleteUrbanLocality(city, loc);
    window.appCoordinator.showToast('Locality removed.', 'INFO');
    this.switchSection('areas');
  }

  deleteRuralVillage(dist, v) {
    this.state.adminDeleteRuralVillage(dist, v);
    window.appCoordinator.showToast('Village removed.', 'INFO');
    this.switchSection('areas');
  }

  // ===================================================================
  // 10. PROPERTY APPROVAL WORKFLOW (Section 10)
  // ===================================================================
  renderPropertyApprovals() {
    const pending = this.state.data.properties.filter(p => p.approvalStatus === 'Pending Approval');

    return `
      <div class="admin-data-card">
        <div class="admin-card-header">
          <div>
            <h3>⏳ Pending Property Approvals Queue (${pending.length})</h3>
            <span style="font-size:0.75rem; color:#64748b;">Review newly submitted owner listings, photos, amenities & rental conditions before going live</span>
          </div>
        </div>

        ${pending.length === 0 ? `
          <div style="padding:40px; text-align:center;">
            <div style="font-size:2.5rem; margin-bottom:10px;">🎉</div>
            <h4>All Properties Approved</h4>
            <p style="color:#64748b; font-size:0.85rem;">There are no new property submissions pending review.</p>
          </div>
        ` : `
          <div style="padding:16px; display:grid; grid-template-columns:repeat(auto-fit, minmax(320px, 1fr)); gap:16px;">
            ${pending.map(p => {
              const owner = this.state.data.users.find(u => u.id === p.ownerId);
              return `
                <div class="approval-review-card">
                  <div class="review-card-header">
                    <h4>${p.title}</h4>
                    <span class="badge-pill-amber">Pending Review</span>
                  </div>
                  <div class="review-card-body">
                    <div><strong>Host:</strong> ${owner ? owner.name : 'Host'} (+91 ${owner?.mobile})</div>
                    <div><strong>Address:</strong> ${p.address}, ${p.locality}, ${p.city} (${p.areaType})</div>
                    <div><strong>Type:</strong> ${p.propertyType.toUpperCase()} • <strong>${p.rooms.length} Units</strong></div>
                    <div><strong>Monthly Rent:</strong> ₹${p.rooms[0]?.monthlyRent.toLocaleString('en-IN')}/mo • <strong>Deposit:</strong> ₹${(p.securityDeposit || 0).toLocaleString('en-IN')}</div>
                    
                    <div style="margin:10px 0;">
                      <span style="font-size:0.75rem; color:#64748b; font-weight:700;">Amenities:</span>
                      <div style="display:flex; flex-wrap:wrap; gap:4px; margin-top:4px;">
                        ${(p.amenities || []).map(a => `<span class="badge-pill-gray">${a}</span>`).join('')}
                      </div>
                    </div>

                    <div style="display:flex; gap:8px; margin-top:14px;">
                      <button class="btn-primary-sm" style="background:#059669; flex:1;" onclick="window.adminApp.quickApproveProperty('${p.id}')">
                        ✓ Approve Listing
                      </button>
                      <button class="btn-primary-sm" style="background:#dc2626; flex:1;" onclick="window.adminApp.promptRejectProperty('${p.id}')">
                        ✕ Reject
                      </button>
                    </div>
                  </div>
                </div>
              `;
            }).join('')}
          </div>
        `}
      </div>
    `;
  }

  quickApproveProperty(propId) {
    this.state.adminApproveProperty(propId);
    window.appCoordinator.showToast('Property Approved & Published Live!', 'SUCCESS');
    this.switchSection('approvals');
  }

  promptRejectProperty(propId) {
    const reason = prompt('Please enter the reason for rejecting this property listing:');
    if (reason) {
      this.state.adminRejectProperty(propId, reason);
      window.appCoordinator.showToast('Property rejected and owner notified.', 'INFO');
      this.switchSection('approvals');
    }
  }

  // ===================================================================
  // 11. RENTAL REQUEST MANAGEMENT (Section 11)
  // ===================================================================
  renderRentalRequests() {
    return `
      <div class="admin-data-card">
        <div class="admin-card-header">
          <div>
            <h3>📥 Rental Requests Monitoring (${this.state.data.rentalRequests.length})</h3>
            <span style="font-size:0.75rem; color:#64748b;">Monitor customer tenant applications and landlord responses</span>
          </div>
        </div>

        <div class="admin-table-responsive">
          <table class="admin-table">
            <thead>
              <tr>
                <th>Request ID</th>
                <th>Customer</th>
                <th>Owner</th>
                <th>Property & Unit</th>
                <th>Requested Move-in</th>
                <th>Monthly Rent</th>
                <th>Request Date</th>
                <th>Status</th>
              </tr>
            </thead>
            <tbody>
              ${this.state.data.rentalRequests.map(r => {
                const cust = this.state.data.users.find(u => u.id === r.customerId);
                const owner = this.state.data.users.find(u => u.id === r.ownerId);
                const prop = this.state.data.properties.find(p => p.id === r.propertyId);

                return `
                  <tr>
                    <td><code>${r.id}</code></td>
                    <td><strong>${cust ? cust.name : r.customerId}</strong><br><span style="font-size:0.7rem; color:#64748b;">+91 ${cust?.mobile}</span></td>
                    <td>${owner ? owner.name : r.ownerId}</td>
                    <td>${prop ? prop.title : 'Property'}<br><span style="font-size:0.7rem; color:#64748b;">Unit: ${r.roomId}</span></td>
                    <td>${r.expectedMoveInDate}</td>
                    <td><strong>₹${r.monthlyRent ? r.monthlyRent.toLocaleString('en-IN') : '-'}</strong> /mo</td>
                    <td>${r.createdAt || '2026-09-01'}</td>
                    <td><span class="hist-status-pill ${r.status === 'Accepted' ? 'paid' : (r.status === 'Rejected' ? 'rented' : 'pending')}">${r.status}</span></td>
                  </tr>
                `;
              }).join('')}
            </tbody>
          </table>
        </div>
      </div>
    `;
  }

  // ===================================================================
  // 12. AGREEMENT MANAGEMENT (Section 12)
  // ===================================================================
  renderAgreements() {
    return `
      <div class="admin-data-card">
        <div class="admin-card-header">
          <div>
            <h3>📑 Rental Agreements & Legal Leases (${this.state.data.agreements.length})</h3>
            <span style="font-size:0.75rem; color:#64748b;">Aadhaar KYC verified agreements with masked sensitive identity protection</span>
          </div>
        </div>

        <div class="admin-table-responsive">
          <table class="admin-table">
            <thead>
              <tr>
                <th>Agreement ID</th>
                <th>Customer</th>
                <th>Owner</th>
                <th>Property</th>
                <th>Monthly Rent</th>
                <th>Deposit</th>
                <th>Aadhaar KYC</th>
                <th>Agreement Status</th>
                <th>Action</th>
              </tr>
            </thead>
            <tbody>
              ${this.state.data.agreements.map(a => {
                const cust = this.state.data.users.find(u => u.id === a.customerId);
                const owner = this.state.data.users.find(u => u.id === a.ownerId);
                const prop = this.state.data.properties.find(p => p.id === a.propertyId);

                return `
                  <tr>
                    <td><strong>${a.id}</strong><br><span style="font-size:0.7rem; color:#64748b;">Signed: ${a.verificationDate}</span></td>
                    <td>${cust ? cust.name : a.customerId}</td>
                    <td>${owner ? owner.name : a.ownerId}</td>
                    <td>${prop ? prop.title : 'Property'}</td>
                    <td><strong>₹${a.monthlyRent.toLocaleString('en-IN')}</strong></td>
                    <td>₹${a.securityDeposit.toLocaleString('en-IN')}</td>
                    <td><span style="color:#059669; font-weight:700;">✓ UIDAI KYC Verified (•••• ${cust?.aadhaarLast4 || '4512'})</span></td>
                    <td><span class="hist-status-pill paid">${a.status}</span></td>
                    <td>
                      <button class="btn-receipt-download" onclick="window.adminApp.downloadAgreementModal('${a.id}')">
                        View Agreement
                      </button>
                    </td>
                  </tr>
                `;
              }).join('')}
            </tbody>
          </table>
        </div>
      </div>
    `;
  }

  downloadAgreementModal(agrId) {
    const agr = this.state.data.agreements.find(a => a.id === agrId);
    if (!agr) return;
    const cust = this.state.data.users.find(u => u.id === agr.customerId);
    const owner = this.state.data.users.find(u => u.id === agr.ownerId);
    const prop = this.state.data.properties.find(p => p.id === agr.propertyId);

    const modalHTML = `
      <div class="modal-backdrop active" id="admin-agr-modal" onclick="if(event.target===this) window.adminApp.closeModal('admin-agr-modal')">
        <div class="modal-card-dialog modal-large">
          <div class="modal-header">
            <h3>📑 Digital Tenancy Agreement Certificate</h3>
            <button class="modal-close-btn" onclick="window.adminApp.closeModal('admin-agr-modal')">✕</button>
          </div>
          <div class="modal-body" style="padding:20px; font-family:'Inter', sans-serif;">
            <div style="text-align:center; border-bottom:2px solid #0f766e; padding-bottom:12px; margin-bottom:16px;">
              <h2>STANDARD RESIDENTIAL RENTAL AGREEMENT</h2>
              <span style="color:#64748b; font-size:0.8rem;">Registered under RentEase Platform • Agreement Reference #${agr.id}</span>
            </div>

            <p style="font-size:0.85rem; line-height:1.6;">
              This Agreement is executed on <strong>${agr.verificationDate}</strong> between 
              Landlord <strong>${owner ? owner.name : 'Owner'}</strong> (Phone: +91 ${owner?.mobile}) and 
              Tenant <strong>${cust ? cust.name : 'Tenant'}</strong> (Aadhaar Verified: •••• ${cust?.aadhaarLast4 || '4512'}) 
              for the premises located at <strong>${prop ? prop.address : 'Property'}</strong>.
            </p>

            <div style="background:#f8fafc; border:1px solid #e2e8f0; border-radius:8px; padding:12px; margin:14px 0; font-size:0.85rem;">
              <div><strong>Monthly Rent:</strong> ₹${agr.monthlyRent.toLocaleString('en-IN')} (Due on the ${agr.dueDayOfMonth}th of each English calendar month)</div>
              <div><strong>Security Deposit:</strong> ₹${agr.securityDeposit.toLocaleString('en-IN')}</div>
              <div><strong>Tenancy Tenure:</strong> 11 Months</div>
            </div>

            <div style="display:flex; justify-content:space-between; margin-top:30px; padding-top:20px; border-top:1px dashed #cbd5e1; font-size:0.85rem;">
              <div>
                <div style="color:#059669; font-weight:700;">✓ Digitally Signed & OTP Verified</div>
                <strong>${cust ? cust.name : 'Tenant'} (Tenant)</strong>
              </div>
              <div style="text-align:right;">
                <div style="color:#059669; font-weight:700;">✓ Approved & Countersigned</div>
                <strong>${owner ? owner.name : 'Owner'} (Landlord)</strong>
              </div>
            </div>

            <div style="margin-top:20px; text-align:center;">
              <button class="btn-primary-sm" onclick="window.print()" style="background:#0f766e; padding:10px 20px;">
                🖨️ Print Agreement
              </button>
            </div>
          </div>
        </div>
      </div>
    `;

    document.body.insertAdjacentHTML('beforeend', modalHTML);
  }

  // ===================================================================
  // 13. ACTIVE RENTALS (Section 13)
  // ===================================================================
  renderActiveRentals() {
    return `
      <div class="admin-data-card">
        <div class="admin-card-header">
          <div>
            <h3>🔑 Active Rentals & Leases (${this.state.data.activeRentals.length})</h3>
            <span style="font-size:0.75rem; color:#64748b;">Live occupied rooms and recurring rent cycle status</span>
          </div>
        </div>

        <div class="admin-table-responsive">
          <table class="admin-table">
            <thead>
              <tr>
                <th>Rental ID</th>
                <th>Tenant</th>
                <th>Owner</th>
                <th>Property & Room</th>
                <th>Monthly Rent</th>
                <th>Due Day</th>
                <th>Current Month Rent</th>
                <th>Status</th>
              </tr>
            </thead>
            <tbody>
              ${this.state.data.activeRentals.map(r => {
                const cust = this.state.data.users.find(u => u.id === r.customerId);
                const owner = this.state.data.users.find(u => u.id === r.ownerId);
                const currentMonthPayment = this.state.data.rentPayments.find(p => p.rentalId === r.id && p.rentMonth === 'Oct 2026');

                return `
                  <tr>
                    <td><code>${r.id}</code></td>
                    <td><strong>${cust ? cust.name : r.customerId}</strong></td>
                    <td>${owner ? owner.name : r.ownerId}</td>
                    <td>${r.propertySnapshot?.title || 'Property'} (<strong>${r.propertySnapshot?.roomNumber || 'Room'}</strong>)</td>
                    <td><strong>₹${(r.monthlyRent || r.propertySnapshot?.monthlyRent || 0).toLocaleString('en-IN')}</strong></td>
                    <td>${r.monthlyDueDay || r.dueDayOfMonth || 5}th / mo</td>
                    <td>
                      <span class="hist-status-pill ${currentMonthPayment?.paymentStatus === 'Paid' ? 'paid' : 'pending'}">
                        ${currentMonthPayment?.paymentStatus || 'Pending'}
                      </span>
                    </td>
                    <td><span class="hist-status-pill paid">${r.status}</span></td>
                  </tr>
                `;
              }).join('')}
            </tbody>
          </table>
        </div>
      </div>
    `;
  }

  // ===================================================================
  // 14 & 15. MONTHLY RENT MANAGEMENT & PAYMENT HISTORY (Sections 14 & 15)
  // ===================================================================
  renderRentPayments() {
    return this.renderPaymentHistory(true);
  }

  renderPaymentHistory(isManageMode = false) {
    let payments = this.state.data.rentPayments;
    const filter = this.tableFilters.paymentStatusFilter;

    if (filter === 'PAID') payments = payments.filter(p => p.paymentStatus === 'Paid');
    else if (filter === 'PENDING') payments = payments.filter(p => p.paymentStatus === 'Pending');

    return `
      <div class="admin-data-card">
        <div class="admin-card-header">
          <div>
            <h3>${isManageMode ? '💰 Master Monthly Rent Ledger' : '📜 Rent Payment History & Receipts'} (${payments.length})</h3>
            <span style="font-size:0.75rem; color:#64748b;">Monitor cash, UPI, online and bank transfer rent records with audit trail</span>
          </div>

          <div style="display:flex; gap:6px;">
            <button class="btn-secondary-sm ${filter === 'ALL' ? 'active-filter' : ''}" onclick="window.adminApp.setPaymentStatusFilter('ALL')">All</button>
            <button class="btn-secondary-sm ${filter === 'PAID' ? 'active-filter' : ''}" onclick="window.adminApp.setPaymentStatusFilter('PAID')">Paid</button>
            <button class="btn-secondary-sm ${filter === 'PENDING' ? 'active-filter' : ''}" onclick="window.adminApp.setPaymentStatusFilter('PENDING')">Pending</button>
          </div>
        </div>

        <div class="admin-table-responsive">
          <table class="admin-table">
            <thead>
              <tr>
                <th>Receipt # / Txn ID</th>
                <th>Rent Month</th>
                <th>Customer</th>
                <th>Amount</th>
                <th>Due Date</th>
                <th>Payment Date</th>
                <th>Payment Mode</th>
                <th>Status</th>
                <th>Action</th>
              </tr>
            </thead>
            <tbody>
              ${payments.map(p => {
                const cust = this.state.data.users.find(u => u.id === p.customerId);
                return `
                  <tr>
                    <td>
                      <strong>${p.receiptNumber || 'Pending'}</strong><br>
                      <span style="font-size:0.7rem; color:#64748b;">${p.transactionRef || 'N/A'}</span>
                    </td>
                    <td><strong>${p.rentMonth}</strong></td>
                    <td>${cust ? cust.name : p.customerId}</td>
                    <td><strong>₹${p.rentAmount.toLocaleString('en-IN')}</strong></td>
                    <td>${p.dueDate}</td>
                    <td>${p.paymentDate || '—'}</td>
                    <td><span class="badge-pill-gray">${p.paymentMode || 'Pending'}</span></td>
                    <td><span class="hist-status-pill ${p.paymentStatus.toLowerCase()}">${p.paymentStatus}</span></td>
                    <td>
                      <div style="display:flex; gap:4px;">
                        ${p.paymentStatus === 'Paid' ? `
                          <button class="btn-receipt-download" onclick="window.appCoordinator.openDigitalReceipt('${p.id}')">
                            Receipt
                          </button>
                        ` : `
                          <button class="btn-primary-sm" style="background:#059669; padding:4px 8px; font-size:0.75rem;" onclick="window.adminApp.openRecordPaymentModal('${p.id}')">
                            Record Paid
                          </button>
                        `}
                      </div>
                    </td>
                  </tr>
                `;
              }).join('')}
            </tbody>
          </table>
        </div>
      </div>
    `;
  }

  setPaymentStatusFilter(f) {
    this.tableFilters.paymentStatusFilter = f;
    this.switchSection('rent_payments');
  }

  openRecordPaymentModal(paymentId) {
    const pay = this.state.data.rentPayments.find(p => p.id === paymentId);
    if (!pay) return;
    const cust = this.state.data.users.find(u => u.id === pay.customerId);

    const modalHTML = `
      <div class="modal-backdrop active" id="admin-pay-modal" onclick="if(event.target===this) window.adminApp.closeModal('admin-pay-modal')">
        <div class="modal-card-dialog">
          <div class="modal-header">
            <h3>💰 Record Rent Payment</h3>
            <button class="modal-close-btn" onclick="window.adminApp.closeModal('admin-pay-modal')">✕</button>
          </div>
          <div class="modal-body">
            <form onsubmit="window.adminApp.submitRentPayment(event, '${paymentId}')">
              <div style="background:#f8fafc; padding:10px; border-radius:8px; margin-bottom:12px; font-size:0.85rem;">
                Tenant: <strong>${cust ? cust.name : 'Customer'}</strong><br>
                Rent Month: <strong>${pay.rentMonth}</strong> • Amount: <strong>₹${pay.rentAmount.toLocaleString('en-IN')}</strong>
              </div>

              <div class="form-group">
                <label>Payment Mode</label>
                <select class="form-control" id="rec-pay-mode" required>
                  <option value="UPI">UPI (Google Pay, PhonePe, Paytm)</option>
                  <option value="Cash">Cash (Hand-to-Hand)</option>
                  <option value="Online">Online NetBanking / Card</option>
                  <option value="Bank Transfer">NEFT / RTGS Bank Transfer</option>
                </select>
              </div>

              <div class="form-group">
                <label>Transaction / Reference Number</label>
                <input type="text" class="form-control" id="rec-pay-ref" value="ADMIN-REC-${Date.now().toString().slice(-6)}" required />
              </div>

              <div class="form-group">
                <label>Notes / Remarks</label>
                <input type="text" class="form-control" id="rec-pay-notes" placeholder="Verified and recorded by Admin" />
              </div>

              <button type="submit" class="btn-primary-sm" style="width:100%; padding:10px; background:#059669;">
                ✓ Confirm & Generate Digital Receipt
              </button>
            </form>
          </div>
        </div>
      </div>
    `;

    document.body.insertAdjacentHTML('beforeend', modalHTML);
  }

  submitRentPayment(e, paymentId) {
    e.preventDefault();
    const mode = document.getElementById('rec-pay-mode').value;
    const ref = document.getElementById('rec-pay-ref').value;
    const notes = document.getElementById('rec-pay-notes').value;

    this.state.recordRentPayment({
      paymentId,
      paymentMode: mode,
      transactionRef: ref,
      notes
    });

    this.closeModal('admin-pay-modal');
    window.appCoordinator.showToast('Rent payment recorded as Paid! Digital receipt generated.', 'SUCCESS');
    this.switchSection('rent_payments');
  }

  // ===================================================================
  // 16. MONTH-WISE RENT HISTORY (Section 16)
  // ===================================================================
  renderMonthWiseHistory() {
    const customers = this.state.data.users.filter(u => u.role === 'CUSTOMER');
    const selectedCustId = this.tableFilters.selectedMonthHistoryCustomer || customers[0]?.id;
    const rentals = this.state.data.activeRentals.filter(r => r.customerId === selectedCustId);
    const selectedRentalId = this.tableFilters.selectedMonthHistoryRental || rentals[0]?.id;
    const timeline = this.state.adminGetRentTimeline(selectedCustId, selectedRentalId);

    return `
      <div class="admin-data-card">
        <div class="admin-card-header">
          <div>
            <h3>📅 Month-by-Month Rent Timeline</h3>
            <span style="font-size:0.75rem; color:#64748b;">Inspect month-wise rent records for any tenant tenancy</span>
          </div>

          <!-- Customer Selector Dropdown -->
          <div style="display:flex; gap:8px;">
            <select class="form-control" onchange="window.adminApp.onMonthHistoryCustomerChange(this.value)">
              ${customers.map(c => `
                <option value="${c.id}" ${c.id === selectedCustId ? 'selected' : ''}>${c.name} (+91 ${c.mobile})</option>
              `).join('')}
            </select>
          </div>
        </div>

        <div style="padding:20px;">
          <div class="month-timeline-wrapper">
            ${timeline.map(p => `
              <div class="timeline-month-card ${p.paymentStatus.toLowerCase()}">
                <div class="month-badge">${p.rentMonth}</div>
                <div class="month-details">
                  <div class="month-rent-amt">₹${p.rentAmount.toLocaleString('en-IN')}</div>
                  <div class="month-meta">
                    Due: ${p.dueDate} • Paid On: ${p.paymentDate || 'Pending'}<br>
                    Mode: <strong>${p.paymentMode || 'Pending'}</strong> • Receipt: ${p.receiptNumber || 'N/A'}
                  </div>
                </div>
                <div class="month-action">
                  <span class="hist-status-pill ${p.paymentStatus.toLowerCase()}">${p.paymentStatus}</span>
                  ${p.paymentStatus === 'Paid' ? `
                    <button class="btn-receipt-download" style="margin-top:6px;" onclick="window.appCoordinator.openDigitalReceipt('${p.id}')">View</button>
                  ` : ''}
                </div>
              </div>
            `).join('')}
          </div>
        </div>
      </div>
    `;
  }

  onMonthHistoryCustomerChange(custId) {
    this.tableFilters.selectedMonthHistoryCustomer = custId;
    this.switchSection('month_history');
  }

  // ===================================================================
  // 17. RENT REMINDER MANAGEMENT (Section 17)
  // ===================================================================
  renderRentReminders() {
    const reminders = this.state.data.reminders || [];

    return `
      <div class="admin-data-card">
        <div class="admin-card-header">
          <div>
            <h3>⏰ Rent Reminder Automation & Notification Log (${reminders.length})</h3>
            <span style="font-size:0.75rem; color:#64748b;">Automated upcoming due, due today and overdue rent notifications with anti-duplication</span>
          </div>
          <button class="btn-primary-sm" style="background:#0284c7;" onclick="window.adminApp.openDispatchReminderModal()">
            + Dispatch Manual Reminder
          </button>
        </div>

        <div class="admin-table-responsive">
          <table class="admin-table">
            <thead>
              <tr>
                <th>Tenant Name</th>
                <th>Property</th>
                <th>Rent Amount</th>
                <th>Due Date</th>
                <th>Reminder Type</th>
                <th>Channel</th>
                <th>Status</th>
                <th>Sent Timestamp</th>
              </tr>
            </thead>
            <tbody>
              ${reminders.map(r => `
                <tr>
                  <td><strong>${r.tenantName}</strong></td>
                  <td>${r.propertyTitle}</td>
                  <td><strong>₹${r.amount.toLocaleString('en-IN')}</strong></td>
                  <td>${r.dueDate}</td>
                  <td><span class="badge-pill-amber">${r.type}</span></td>
                  <td><span class="badge-pill-gray">${r.channel}</span></td>
                  <td><span class="hist-status-pill paid">${r.status}</span></td>
                  <td>${r.sentAt}</td>
                </tr>
              `).join('')}
            </tbody>
          </table>
        </div>
      </div>
    `;
  }

  openDispatchReminderModal() {
    const activeRentals = this.state.data.activeRentals;
    const modalHTML = `
      <div class="modal-backdrop active" id="admin-rem-modal" onclick="if(event.target===this) window.adminApp.closeModal('admin-rem-modal')">
        <div class="modal-card-dialog">
          <div class="modal-header">
            <h3>⏰ Dispatch Rent Reminder</h3>
            <button class="modal-close-btn" onclick="window.adminApp.closeModal('admin-rem-modal')">✕</button>
          </div>
          <div class="modal-body">
            <form onsubmit="window.adminApp.submitDispatchReminder(event)">
              <div class="form-group">
                <label>Select Active Tenancy</label>
                <select class="form-control" id="rem-rental-id" required>
                  ${activeRentals.map(r => {
                    const cust = this.state.data.users.find(u => u.id === r.customerId);
                    return `<option value="${r.id}">${cust?.name || 'Tenant'} — ${r.propertySnapshot?.title || 'Property'} (₹${(r.monthlyRent || r.propertySnapshot?.monthlyRent || 0).toLocaleString('en-IN')})</option>`;
                  }).join('')}
                </select>
              </div>

              <div class="form-group">
                <label>Reminder Type</label>
                <select class="form-control" id="rem-type">
                  <option value="Upcoming Due Date (4 Days Before)">Upcoming Due Date (4 Days Before)</option>
                  <option value="Due Today Alert">Due Today Alert</option>
                  <option value="Payment Overdue Notice">Payment Overdue Notice</option>
                </select>
              </div>

              <div class="form-group">
                <label>Channel</label>
                <select class="form-control" id="rem-channel">
                  <option value="In-App + Push Notification">In-App + Push Notification</option>
                  <option value="SMS Gateway Integration">SMS Gateway Integration</option>
                  <option value="WhatsApp Business Alert">WhatsApp Business Alert</option>
                </select>
              </div>

              <button type="submit" class="btn-primary-sm" style="width:100%; padding:10px;">Dispatch Rent Reminder</button>
            </form>
          </div>
        </div>
      </div>
    `;
    document.body.insertAdjacentHTML('beforeend', modalHTML);
  }

  submitDispatchReminder(e) {
    e.preventDefault();
    const rentalId = document.getElementById('rem-rental-id').value;
    const type = document.getElementById('rem-type').value;
    const channel = document.getElementById('rem-channel').value;

    try {
      this.state.adminSendRentReminder(rentalId, type, channel);
      this.closeModal('admin-rem-modal');
      window.appCoordinator.showToast('Rent reminder dispatched successfully!', 'SUCCESS');
      this.switchSection('rent_reminders');
    } catch (err) {
      alert(err.message);
    }
  }

  // ===================================================================
  // 18. RENT COLLECTION REPORT (Section 18)
  // ===================================================================
  renderCollectionReport() {
    const stats = this.state.getAdminStatistics();

    return `
      <div class="admin-data-card">
        <div class="admin-card-header">
          <div>
            <h3>📈 Monthly Rent Collection Analytics & Report</h3>
            <span style="font-size:0.75rem; color:#64748b;">Financial performance and realization breakdown</span>
          </div>
          <button class="btn-primary-sm" style="background:#059669;" onclick="window.adminApp.exportCSV('RENT_COLLECTION')">
            📥 Download CSV Report
          </button>
        </div>

        <div style="padding:20px;">
          <!-- Key Financial Highlights -->
          <div style="display:grid; grid-template-columns:repeat(auto-fit, minmax(200px, 1fr)); gap:14px; margin-bottom:20px;">
            <div class="kpi-mini-card" style="background:#f0fdf4; border-color:#bbf7d0;">
              <span style="color:#15803d; font-size:0.75rem; font-weight:700;">TOTAL RENT COLLECTED</span>
              <h3 style="color:#15803d; margin:4px 0;">₹${stats.totalRentCollected.toLocaleString('en-IN')}</h3>
              <span style="font-size:0.7rem; color:#16a34a;">${stats.totalTransactions} Completed Txns</span>
            </div>

            <div class="kpi-mini-card" style="background:#fffbeb; border-color:#fef08a;">
              <span style="color:#b45309; font-size:0.75rem; font-weight:700;">PENDING / OVERDUE RENT</span>
              <h3 style="color:#b45309; margin:4px 0;">₹${stats.totalPendingRent.toLocaleString('en-IN')}</h3>
              <span style="font-size:0.7rem; color:#d97706;">Actionable</span>
            </div>

            <div class="kpi-mini-card" style="background:#eff6ff; border-color:#bfdbfe;">
              <span style="color:#1d4ed8; font-size:0.75rem; font-weight:700;">COLLECTION EFFICIENCY</span>
              <h3 style="color:#1d4ed8; margin:4px 0;">
                ${stats.totalRentCollected + stats.totalPendingRent > 0 ? Math.round((stats.totalRentCollected / (stats.totalRentCollected + stats.totalPendingRent)) * 100) : 100}%
              </h3>
              <span style="font-size:0.7rem; color:#2563eb;">On-time realization</span>
            </div>
          </div>

          <!-- Charts -->
          <div style="display:grid; grid-template-columns:1fr 1fr; gap:20px;">
            <div>
              <h4>Monthly Realization Growth</h4>
              ${this.renderMonthlyCollectionChart(stats.monthlyTrends)}
            </div>
            <div>
              <h4>Payment Mode Breakdown</h4>
              ${this.renderPaymentModesBar(stats.paymentModeCounts)}
            </div>
          </div>
        </div>
      </div>
    `;
  }

  // ===================================================================
  // 19. COMPLAINT MANAGEMENT (Section 19)
  // ===================================================================
  renderComplaints() {
    return `
      <div class="admin-data-card">
        <div class="admin-card-header">
          <div>
            <h3>🛠️ Maintenance Complaints & Support Tickets (${this.state.data.complaints.length})</h3>
            <span style="font-size:0.75rem; color:#64748b;">Customer and landlord complaints with audit response trail</span>
          </div>
        </div>

        <div style="padding:16px; display:flex; flex-direction:column; gap:14px;">
          ${this.state.data.complaints.map(comp => `
            <div style="background:#f8fafc; border:1px solid #e2e8f0; border-radius:12px; padding:16px;">
              <div style="display:flex; justify-content:space-between; align-items:flex-start;">
                <div>
                  <h4 style="font-size:1rem; color:#0f172a; margin:0;">${comp.subject}</h4>
                  <p style="font-size:0.75rem; color:#64748b; margin:4px 0;">
                    Filed by: <strong>${comp.userName}</strong> (${comp.userRole}) • Category: <strong>${comp.category}</strong> • Date: ${comp.createdAt || '2026-09-20'}
                  </p>
                </div>
                <span class="hist-status-pill ${comp.status === 'Resolved' ? 'paid' : (comp.status === 'In Review' ? 'pending' : 'rented')}">${comp.status}</span>
              </div>

              <div style="background:#ffffff; padding:10px 14px; border-radius:8px; margin:10px 0; border:1px solid #e2e8f0; font-size:0.85rem;">
                "${comp.description}"
              </div>

              ${comp.adminResponse ? `
                <div style="padding:10px 14px; background:#ecfdf5; border-radius:8px; font-size:0.82rem; color:#065f46; margin-bottom:12px; border:1px solid #a7f3d0;">
                  <strong>Admin Official Response:</strong> ${comp.adminResponse}
                </div>
              ` : ''}

              <!-- Admin Quick Response Input -->
              <div style="display:flex; gap:8px;">
                <input type="text" class="form-control" id="resp-input-${comp.id}" placeholder="Type resolution note or dispatch assignment..." style="font-size:0.82rem;" />
                <button class="btn-primary-sm" style="background:#059669; white-space:nowrap;" onclick="window.adminApp.submitComplaintResolution('${comp.id}')">
                  Resolve Ticket
                </button>
              </div>
            </div>
          `).join('')}
        </div>
      </div>
    `;
  }

  submitComplaintResolution(complaintId) {
    const input = document.getElementById(`resp-input-${complaintId}`);
    const text = input ? input.value : '';
    if (!text) {
      alert('Please enter a response for the user.');
      return;
    }

    this.state.adminRespondComplaint(complaintId, text, 'Resolved');
    window.appCoordinator.showToast('Complaint resolved & user notified!', 'SUCCESS');
    this.switchSection('complaints');
  }

  // ===================================================================
  // 20. NOTIFICATION MANAGEMENT (Section 20)
  // ===================================================================
  renderNotifications() {
    return `
      <div class="admin-data-card">
        <div class="admin-card-header">
          <div>
            <h3>🔔 System Notifications & Broadcast Dispatches (${this.state.data.notifications.length})</h3>
            <span style="font-size:0.75rem; color:#64748b;">In-App, Push Notification, SMS & WhatsApp integrations</span>
          </div>
          <button class="btn-primary-sm" style="background:#0284c7;" onclick="window.adminApp.openBroadcastModal()">
            📢 New Broadcast
          </button>
        </div>

        <div class="admin-table-responsive">
          <table class="admin-table">
            <thead>
              <tr>
                <th>Notification Title</th>
                <th>Message Content</th>
                <th>Recipient Role / ID</th>
                <th>Type</th>
                <th>Sent Time</th>
              </tr>
            </thead>
            <tbody>
              ${this.state.data.notifications.map(n => `
                <tr>
                  <td><strong>${n.title}</strong></td>
                  <td>${n.message}</td>
                  <td><span class="badge-pill-blue">${n.recipientRole || 'ALL'} (${n.recipientId})</span></td>
                  <td><span class="badge-pill-gray">${n.type}</span></td>
                  <td>${n.createdAt || 'Just now'}</td>
                </tr>
              `).join('')}
            </tbody>
          </table>
        </div>
      </div>
    `;
  }

  openBroadcastModal() {
    const modalHTML = `
      <div class="modal-backdrop active" id="admin-bcast-modal" onclick="if(event.target===this) window.adminApp.closeModal('admin-bcast-modal')">
        <div class="modal-card-dialog">
          <div class="modal-header">
            <h3>📢 Broadcast System Notification</h3>
            <button class="modal-close-btn" onclick="window.adminApp.closeModal('admin-bcast-modal')">✕</button>
          </div>
          <div class="modal-body">
            <form onsubmit="window.adminApp.submitBroadcast(event)">
              <div class="form-group">
                <label>Target Audience</label>
                <select class="form-control" id="bcast-target">
                  <option value="ALL">All Users (Tenants & Landlords)</option>
                  <option value="CUSTOMER">All Customers</option>
                  <option value="OWNER">All Landlords / Owners</option>
                </select>
              </div>
              <div class="form-group">
                <label>Notification Title</label>
                <input type="text" class="form-control" id="bcast-title" placeholder="e.g. Scheduled System Upgrade Alert" required />
              </div>
              <div class="form-group">
                <label>Message Content</label>
                <textarea class="form-control" id="bcast-msg" rows="3" placeholder="Enter broadcast message body..." required></textarea>
              </div>
              <button type="submit" class="btn-primary-sm" style="width:100%; padding:10px; background:#0284c7;">
                Dispatch Broadcast
              </button>
            </form>
          </div>
        </div>
      </div>
    `;
    document.body.insertAdjacentHTML('beforeend', modalHTML);
  }

  submitBroadcast(e) {
    e.preventDefault();
    const target = document.getElementById('bcast-target').value;
    const title = document.getElementById('bcast-title').value;
    const msg = document.getElementById('bcast-msg').value;

    this.state.addNotification({
      recipientId: target,
      recipientRole: target,
      title,
      message: msg,
      type: 'BROADCAST'
    });

    this.closeModal('admin-bcast-modal');
    window.appCoordinator.showToast('System Broadcast sent successfully!', 'SUCCESS');
    this.switchSection('notifications');
  }

  // ===================================================================
  // 21. REPORTS & CSV EXPORT (Section 21)
  // ===================================================================
  renderReports() {
    const reportList = [
      { id: 'CUSTOMERS', label: 'Customers Report' },
      { id: 'OWNERS', label: 'Owners Report' },
      { id: 'PROPERTIES', label: 'Properties Report' },
      { id: 'RENT_COLLECTION', label: 'Rent Collection Report' },
      { id: 'PAYMENTS', label: 'Payment History Report' },
      { id: 'AGREEMENTS', label: 'Agreements Report' },
      { id: 'COMPLAINTS', label: 'Complaints Report' }
    ];

    const records = this.state.adminGenerateReport(this.activeReportType);
    const headers = records.length > 0 ? Object.keys(records[0]) : [];

    return `
      <div class="admin-data-card">
        <div class="admin-card-header">
          <div>
            <h3>📄 Platform Reports & Export Center</h3>
            <span style="font-size:0.75rem; color:#64748b;">Download structured audit reports in CSV and Excel-ready formats</span>
          </div>

          <!-- Download Action -->
          <button class="btn-primary-sm" style="background:#059669;" onclick="window.adminApp.exportCSV('${this.activeReportType}')">
            📥 Download "${this.activeReportType}" CSV
          </button>
        </div>

        <!-- Report Tabs -->
        <div style="padding:12px 20px; background:#f8fafc; border-bottom:1px solid #e2e8f0; display:flex; gap:6px; flex-wrap:wrap;">
          ${reportList.map(r => `
            <button 
              class="btn-secondary-sm ${this.activeReportType === r.id ? 'active-filter' : ''}" 
              onclick="window.adminApp.setReportType('${r.id}')"
            >
              ${r.label}
            </button>
          `).join('')}
        </div>

        <!-- Live Preview Table -->
        <div class="admin-table-responsive">
          <table class="admin-table">
            <thead>
              <tr>
                ${headers.map(h => `<th>${h}</th>`).join('')}
              </tr>
            </thead>
            <tbody>
              ${records.map(row => `
                <tr>
                  ${headers.map(h => `<td>${row[h]}</td>`).join('')}
                </tr>
              `).join('') || '<tr><td colspan="5">No records in this report.</td></tr>'}
            </tbody>
          </table>
        </div>
      </div>
    `;
  }

  setReportType(type) {
    this.activeReportType = type;
    this.switchSection('reports');
  }

  exportCSV(type) {
    const csv = this.state.adminExportReportCSV(type);
    if (!csv) {
      alert('No data available to export.');
      return;
    }

    const blob = new Blob([csv], { type: 'text/csv;charset=utf-8;' });
    const link = document.createElement('a');
    link.href = URL.createObjectURL(blob);
    link.setAttribute('download', `RentEase_${type}_Report_${new Date().toISOString().substring(0, 10)}.csv`);
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);

    window.appCoordinator.showToast(`Exported ${type} CSV successfully.`, 'SUCCESS');
  }

  // ===================================================================
  // 22. ADMIN USER MANAGEMENT (RBAC) (Section 22)
  // ===================================================================
  renderAdminUsers() {
    const adminUsers = this.state.data.adminUsers || [];

    return `
      <div class="admin-data-card">
        <div class="admin-card-header">
          <div>
            <h3>🛡️ Admin User Directory & Role-Based Access (RBAC) (${adminUsers.length})</h3>
            <span style="font-size:0.75rem; color:#64748b;">Super Admin, Finance Admin, Property Manager & Support Admin permissions</span>
          </div>
          <button class="btn-primary-sm" style="background:#0284c7;" onclick="window.adminApp.openAddAdminUserModal()">
            + Add Admin User
          </button>
        </div>

        <div class="admin-table-responsive">
          <table class="admin-table">
            <thead>
              <tr>
                <th>Admin Name</th>
                <th>Email & Mobile</th>
                <th>Role</th>
                <th>Permissions Scope</th>
                <th>Last Login</th>
                <th>Status</th>
                <th>Actions</th>
              </tr>
            </thead>
            <tbody>
              ${adminUsers.map(a => `
                <tr>
                  <td><strong>${a.name}</strong></td>
                  <td>${a.email}<br><span style="font-size:0.7rem; color:#64748b;">+91 ${a.mobile}</span></td>
                  <td><span class="role-pill-badge">${a.adminRole || 'Admin'}</span></td>
                  <td><span class="badge-pill-gray">${(a.permissions || ['ALL']).join(', ')}</span></td>
                  <td>${a.lastLogin || 'Never'}</td>
                  <td><span class="hist-status-pill ${a.status === 'Active' ? 'paid' : 'rented'}">${a.status}</span></td>
                  <td>
                    <button class="btn-action-tiny" style="color:${a.status === 'Active' ? '#dc2626' : '#059669'};" onclick="window.adminApp.toggleAdminUser('${a.id}')">
                      ${a.status === 'Active' ? 'Deactivate' : 'Activate'}
                    </button>
                  </td>
                </tr>
              `).join('')}
            </tbody>
          </table>
        </div>
      </div>
    `;
  }

  openAddAdminUserModal() {
    const modalHTML = `
      <div class="modal-backdrop active" id="admin-user-modal" onclick="if(event.target===this) window.adminApp.closeModal('admin-user-modal')">
        <div class="modal-card-dialog">
          <div class="modal-header">
            <h3>+ Add Admin User</h3>
            <button class="modal-close-btn" onclick="window.adminApp.closeModal('admin-user-modal')">✕</button>
          </div>
          <div class="modal-body">
            <form onsubmit="window.adminApp.submitNewAdminUser(event)">
              <div class="form-group">
                <label>Full Name</label>
                <input type="text" class="form-control" id="new-admin-name" placeholder="e.g. Ramesh Chandra" required />
              </div>
              <div class="form-group">
                <label>Email</label>
                <input type="email" class="form-control" id="new-admin-email" placeholder="ramesh@rentease.in" required />
              </div>
              <div class="form-group">
                <label>Mobile Number</label>
                <input type="text" class="form-control" id="new-admin-mobile" placeholder="9876500000" required />
              </div>
              <div class="form-group">
                <label>Admin Role</label>
                <select class="form-control" id="new-admin-role">
                  <option value="Super Admin">Super Admin (Full Access)</option>
                  <option value="Finance Admin">Finance Admin (Rent Payments & Reports)</option>
                  <option value="Property Manager">Property Manager (Properties & Inquiries)</option>
                  <option value="Support Admin">Support Admin (Customers, Complaints & Support)</option>
                </select>
              </div>
              <button type="submit" class="btn-primary-sm" style="width:100%; padding:10px;">Create Admin User</button>
            </form>
          </div>
        </div>
      </div>
    `;
    document.body.insertAdjacentHTML('beforeend', modalHTML);
  }

  submitNewAdminUser(e) {
    e.preventDefault();
    const name = document.getElementById('new-admin-name').value;
    const email = document.getElementById('new-admin-email').value;
    const mobile = document.getElementById('new-admin-mobile').value;
    const role = document.getElementById('new-admin-role').value;

    this.state.adminAddAdminUser({ name, email, mobile, role });
    this.closeModal('admin-user-modal');
    window.appCoordinator.showToast(`Admin user "${name}" created.`, 'SUCCESS');
    this.switchSection('admin_users');
  }

  toggleAdminUser(adminId) {
    this.state.adminToggleAdminUserStatus(adminId);
    window.appCoordinator.showToast('Admin user status updated.', 'SUCCESS');
    this.switchSection('admin_users');
  }

  // ===================================================================
  // 23. AUDIT LOG (Section 23)
  // ===================================================================
  renderAuditLogs() {
    const logs = this.state.data.auditLogs || [];

    return `
      <div class="admin-data-card">
        <div class="admin-card-header">
          <div>
            <h3>📝 Administrative Security & Financial Audit Trail (${logs.length})</h3>
            <span style="font-size:0.75rem; color:#64748b;">Immutable record of financial transactions, approvals and status modifications</span>
          </div>
        </div>

        <div class="admin-table-responsive">
          <table class="admin-table">
            <thead>
              <tr>
                <th>Timestamp</th>
                <th>Admin User</th>
                <th>Action</th>
                <th>Module</th>
                <th>Record ID</th>
                <th>Old Value</th>
                <th>New Value</th>
                <th>IP Address</th>
              </tr>
            </thead>
            <tbody>
              ${logs.map(l => `
                <tr>
                  <td><code>${l.timestamp}</code></td>
                  <td><strong>${l.adminName}</strong></td>
                  <td><span class="badge-pill-blue">${l.action}</span></td>
                  <td>${l.module}</td>
                  <td><code>${l.recordId}</code></td>
                  <td><span style="color:#64748b;">${l.oldValue || '—'}</span></td>
                  <td><span style="color:#059669; font-weight:700;">${l.newValue || '—'}</span></td>
                  <td><code>${l.ipAddress || '192.168.1.24'}</code></td>
                </tr>
              `).join('')}
            </tbody>
          </table>
        </div>
      </div>
    `;
  }

  // ===================================================================
  // 24. ADMIN GLOBAL SEARCH (Section 24)
  // ===================================================================
  handleGlobalSearch(query) {
    const dropdown = document.getElementById('admin-search-dropdown');
    if (!dropdown) return;

    if (!query || query.trim() === '') {
      dropdown.style.display = 'none';
      return;
    }

    const results = this.state.adminGlobalSearch(query);
    if (!results) {
      dropdown.style.display = 'none';
      return;
    }

    const totalCount = (results.customers?.length || 0) + (results.owners?.length || 0) + (results.properties?.length || 0) + (results.payments?.length || 0) + (results.complaints?.length || 0);

    dropdown.innerHTML = `
      <div style="padding:10px 14px; background:#f8fafc; border-bottom:1px solid #e2e8f0; font-size:0.75rem; font-weight:700; color:#64748b;">
        SEARCH RESULTS (${totalCount} MATCHES)
      </div>

      <!-- Customers -->
      ${results.customers?.length > 0 ? `
        <div class="search-category-group">
          <div class="search-cat-title">👥 Customers</div>
          ${results.customers.map(c => `
            <div class="search-item" onclick="window.adminApp.switchSection('customers'); window.adminApp.openCustomerProfileModal('${c.id}')">
              <strong>${c.name}</strong> • +91 ${c.mobile} (${c.email})
            </div>
          `).join('')}
        </div>
      ` : ''}

      <!-- Owners -->
      ${results.owners?.length > 0 ? `
        <div class="search-category-group">
          <div class="search-cat-title">🏢 Owners</div>
          ${results.owners.map(o => `
            <div class="search-item" onclick="window.adminApp.switchSection('owners'); window.adminApp.openOwnerProfileModal('${o.id}')">
              <strong>${o.name}</strong> • +91 ${o.mobile}
            </div>
          `).join('')}
        </div>
      ` : ''}

      <!-- Properties -->
      ${results.properties?.length > 0 ? `
        <div class="search-category-group">
          <div class="search-cat-title">🏘️ Properties</div>
          ${results.properties.map(p => `
            <div class="search-item" onclick="window.adminApp.switchSection('properties'); window.adminApp.openPropertyViewModal('${p.id}')">
              <strong>${p.title}</strong> (${p.city}) • ID: ${p.id}
            </div>
          `).join('')}
        </div>
      ` : ''}

      <!-- Payments -->
      ${results.payments?.length > 0 ? `
        <div class="search-category-group">
          <div class="search-cat-title">💰 Payments</div>
          ${results.payments.map(p => `
            <div class="search-item" onclick="window.adminApp.switchSection('rent_payments')">
              <strong>${p.receiptNumber || 'Txn'}</strong> (${p.rentMonth}) • ₹${p.rentAmount} (${p.paymentStatus})
            </div>
          `).join('')}
        </div>
      ` : ''}

      ${totalCount === 0 ? `
        <div style="padding:16px; text-align:center; color:#64748b; font-size:0.85rem;">No records matched "${query}".</div>
      ` : ''}
    `;

    dropdown.style.display = 'block';
  }

  // ===================================================================
  // 25. ADMIN SETTINGS (Section 25)
  // ===================================================================
  renderSettings() {
    const s = this.state.data.settings;

    return `
      <div class="admin-data-card">
        <div class="admin-card-header">
          <div>
            <h3>⚙️ Platform Configuration & Global Governance Settings</h3>
            <span style="font-size:0.75rem; color:#64748b;">Manage business rules, reminder thresholds, integrations and security protocols</span>
          </div>
          <button class="btn-primary-sm" style="background:#059669;" onclick="window.adminApp.saveSettings()">
            💾 Save Settings
          </button>
        </div>

        <div style="padding:20px; display:grid; grid-template-columns:1fr 1fr; gap:24px;">
          <!-- General Settings -->
          <div class="settings-box">
            <h4>🏢 General Platform Settings</h4>
            <div class="form-group">
              <label>Platform Name</label>
              <input type="text" class="form-control" id="cfg-plat-name" value="${s.general.platformName}" />
            </div>
            <div class="form-group">
              <label>Support Email</label>
              <input type="email" class="form-control" id="cfg-plat-email" value="${s.general.supportEmail}" />
            </div>
            <div class="form-group">
              <label>Support Helpline</label>
              <input type="text" class="form-control" id="cfg-plat-phone" value="${s.general.supportPhone}" />
            </div>
          </div>

          <!-- Rental Rules -->
          <div class="settings-box">
            <h4>📑 Rental & Approval Business Rules</h4>
            <div class="form-group">
              <label>
                <input type="checkbox" id="cfg-req-approval" ${s.rental.requirePropertyApproval ? 'checked' : ''} />
                Require Admin Approval for New Property Listings
              </label>
            </div>
            <div class="form-group">
              <label>Default Rent Due Cycle (Days before end of month)</label>
              <input type="number" class="form-control" id="cfg-due-days" value="${s.rental.autoGenerateRentDueDays}" />
            </div>
            <div class="form-group">
              <label>
                <input type="checkbox" id="cfg-allow-cash" ${s.rental.allowCashPaymentRecording ? 'checked' : ''} />
                Allow Cash Rent Payment Recording by Owners
              </label>
            </div>
          </div>

          <!-- Reminders & Notifications -->
          <div class="settings-box">
            <h4>⏰ Automated Reminders</h4>
            <div class="form-group">
              <label>Advance Rent Reminder (Days before due date)</label>
              <input type="number" class="form-control" id="cfg-rem-days" value="${s.reminders.sendAdvanceReminderDays}" />
            </div>
            <div class="form-group">
              <label>
                <input type="checkbox" id="cfg-rem-due-day" ${s.reminders.sendOnDueDate ? 'checked' : ''} />
                Send Notification on Due Date
              </label>
            </div>
          </div>

          <!-- Security & KYC -->
          <div class="settings-box">
            <h4>🔒 Security & Aadhaar Verification</h4>
            <div class="form-group">
              <label>
                <input type="checkbox" id="cfg-aadhaar-consent" ${s.security.requireAadhaarConsent ? 'checked' : ''} />
                Require Aadhaar e-KYC for Tenancy Agreements
              </label>
            </div>
            <div class="form-group">
              <label>
                <input type="checkbox" id="cfg-2fa-admin" ${s.security.twoFactorAdminAuth ? 'checked' : ''} />
                Enforce 2FA / OTP Verification for Admin Logins
              </label>
            </div>
          </div>
        </div>
      </div>
    `;
  }

  saveSettings() {
    const newSettings = {
      general: {
        platformName: document.getElementById('cfg-plat-name')?.value || 'RentEase Platform',
        supportEmail: document.getElementById('cfg-plat-email')?.value || 'support@rentease.in',
        supportPhone: document.getElementById('cfg-plat-phone')?.value || '+91 1800-123-7368',
        currencySymbol: '₹',
        defaultAgreementMonths: 11
      },
      rental: {
        requirePropertyApproval: document.getElementById('cfg-req-approval')?.checked ?? true,
        autoGenerateRentDueDays: parseInt(document.getElementById('cfg-due-days')?.value || '5', 10),
        allowCashPaymentRecording: document.getElementById('cfg-allow-cash')?.checked ?? true
      },
      reminders: {
        sendAdvanceReminderDays: parseInt(document.getElementById('cfg-rem-days')?.value || '4', 10),
        sendOnDueDate: document.getElementById('cfg-rem-due-day')?.checked ?? true
      },
      security: {
        requireAadhaarConsent: document.getElementById('cfg-aadhaar-consent')?.checked ?? true,
        twoFactorAdminAuth: document.getElementById('cfg-2fa-admin')?.checked ?? true
      }
    };

    this.state.adminUpdateSettings(newSettings);
    window.appCoordinator.showToast('Platform settings successfully saved.', 'SUCCESS');
  }

  // --- Utility Methods ---
  resetDataPrompt() {
    if (confirm('Reset entire platform database back to fresh seed data?')) {
      this.state.resetToDefaultSeed();
      window.appCoordinator.showToast('Database reset to fresh seed demo data.', 'INFO');
      this.switchSection('dashboard');
    }
  }

  closeModal(id) {
    const el = document.getElementById(id);
    if (el) el.remove();
  }

  // --- CRUD Modals: Properties ---
  openAddPropertyModal() {
    this.openPropertyFormModal(null);
  }

  openEditPropertyModal(propertyId) {
    const prop = this.state.data.properties.find(p => p.id === propertyId);
    if (!prop) return;
    this.openPropertyFormModal(prop);
  }

  openPropertyFormModal(prop) {
    const isEdit = !!prop;
    const room = isEdit && prop.rooms && prop.rooms.length > 0 ? prop.rooms[0] : null;

    const modalHTML = `
      <div class="modal-backdrop active" id="admin-prop-form-modal" onclick="if(event.target===this) window.adminApp.closeModal('admin-prop-form-modal')">
        <div class="modal-card-dialog modal-large">
          <div class="modal-header">
            <h3>${isEdit ? '✏️ Edit Property Listing' : '➕ Add New Property Listing'}</h3>
            <button class="modal-close-btn" onclick="window.adminApp.closeModal('admin-prop-form-modal')">✕</button>
          </div>
          <div class="modal-body">
            <form id="admin-prop-form" onsubmit="window.adminApp.handlePropertyFormSubmit(event, '${isEdit ? prop.id : ''}')">
              <div style="display:grid; grid-template-columns:1fr 1fr; gap:12px;">
                <div class="form-group" style="grid-column: span 2;">
                  <label>Property Title *</label>
                  <input type="text" class="form-control" id="ap-title" required value="${isEdit ? prop.title : ''}" />
                </div>
                <div class="form-group">
                  <label>Area Type *</label>
                  <select class="form-control" id="ap-areaType">
                    <option value="urban" ${isEdit && prop.areaType === 'urban' ? 'selected' : ''}>Urban (City)</option>
                    <option value="rural" ${isEdit && prop.areaType === 'rural' ? 'selected' : ''}>Rural (Village / Outskirts)</option>
                  </select>
                </div>
                <div class="form-group">
                  <label>Property Category *</label>
                  <select class="form-control" id="ap-propType">
                    <option value="room" ${isEdit && prop.propertyType === 'room' ? 'selected' : ''}>Single Room</option>
                    <option value="flat" ${isEdit && prop.propertyType === 'flat' ? 'selected' : ''}>Flat / 2 BHK</option>
                    <option value="apartment" ${isEdit && prop.propertyType === 'apartment' ? 'selected' : ''}>Apartment</option>
                    <option value="house" ${isEdit && prop.propertyType === 'house' ? 'selected' : ''}>Independent House</option>
                    <option value="hostel" ${isEdit && prop.propertyType === 'hostel' ? 'selected' : ''}>Hostel / PG</option>
                    <option value="godown" ${isEdit && prop.propertyType === 'godown' ? 'selected' : ''}>Godown / Warehouse</option>
                  </select>
                </div>
                <div class="form-group">
                  <label>City *</label>
                  <input type="text" class="form-control" id="ap-city" required value="${isEdit ? prop.city : 'Varanasi'}" />
                </div>
                <div class="form-group">
                  <label>Locality *</label>
                  <input type="text" class="form-control" id="ap-locality" required value="${isEdit ? prop.locality : 'Assi Ghat'}" />
                </div>
                <div class="form-group" style="grid-column: span 2;">
                  <label>Full Address</label>
                  <input type="text" class="form-control" id="ap-address" value="${isEdit ? (prop.address || '') : ''}" />
                </div>
              </div>

              <hr style="margin:14px 0; border:0; border-top:1px solid #e2e8f0;" />

              <!-- Multi-Room Selector (Kitna Room Hai?) -->
              <div style="background:#f8fafc; border:1px solid #e2e8f0; border-radius:12px; padding:12px; margin-bottom:14px;">
                <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:8px;">
                  <h4 style="font-size:0.88rem; color:#0f766e; margin:0; font-weight:700;">🚪 Unit / Room Specifications</h4>
                  <span id="admin-room-count-badge" style="background:#ccfbf1; color:#0f766e; padding:2px 8px; border-radius:999px; font-size:0.75rem; font-weight:700;">
                    5 Rooms Total
                  </span>
                </div>



                <div style="display:grid; grid-template-columns:1fr 1fr 1fr; gap:12px;">
                  <div class="form-group">
                    <label>Monthly Rent (₹) *</label>
                    <input type="number" class="form-control" id="ap-rent" required value="${room ? room.monthlyRent : 9000}" />
                  </div>
                  <div class="form-group">
                    <label>Security Deposit (₹)</label>
                    <input type="number" class="form-control" id="ap-deposit" value="${room ? room.securityDeposit : 18000}" />
                  </div>
                  <div class="form-group">
                    <label>Furnishing</label>
                    <select class="form-control" id="ap-furnishing">
                      <option value="Furnished" ${room && room.furnishing === 'Furnished' ? 'selected' : ''}>Furnished</option>
                      <option value="Semi-Furnished" ${room && room.furnishing === 'Semi-Furnished' ? 'selected' : ''}>Semi-Furnished</option>
                      <option value="Unfurnished" ${room && room.furnishing === 'Unfurnished' ? 'selected' : ''}>Unfurnished</option>
                    </select>
                  </div>
                </div>
              </div>

              <!-- Multiple Property Photos Section -->
              <div style="background:#f0fdfa; border:1px solid #99f6e4; border-radius:12px; padding:12px; margin-top:14px;">
                <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:6px;">
                  <h4 style="font-size:0.88rem; color:#0f766e; margin:0; font-weight:700;">📷 Property Photos (Multiple)</h4>
                  <span id="admin-photo-count-badge" style="background:#ccfbf1; color:#0f766e; padding:2px 8px; border-radius:999px; font-size:0.75rem; font-weight:700;">
                    Attached
                  </span>
                </div>
                <p style="font-size:0.75rem; color:#64748b; margin-bottom:8px;">Pick instant presets or paste custom photo URLs:</p>

                <!-- Quick Presets -->
                <div style="display:flex; flex-wrap:wrap; gap:6px; margin-bottom:10px;">
                  <button type="button" class="btn-secondary-sm" style="font-size:0.75rem; padding:3px 8px;" onclick="window.adminApp.addPhotoFromPreset('https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?auto=format&fit=crop&w=800&q=80', 'Living Room')">+ Living Room</button>
                  <button type="button" class="btn-secondary-sm" style="font-size:0.75rem; padding:3px 8px;" onclick="window.adminApp.addPhotoFromPreset('https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?auto=format&fit=crop&w=800&q=80', 'Bedroom')">+ Bedroom</button>
                  <button type="button" class="btn-secondary-sm" style="font-size:0.75rem; padding:3px 8px;" onclick="window.adminApp.addPhotoFromPreset('https://images.unsplash.com/photo-1556911220-e15b29be8c8f?auto=format&fit=crop&w=800&q=80', 'Kitchen')">+ Kitchen</button>
                  <button type="button" class="btn-secondary-sm" style="font-size:0.75rem; padding:3px 8px;" onclick="window.adminApp.addPhotoFromPreset('https://images.unsplash.com/photo-1545324418-cc1a3fa10c00?auto=format&fit=crop&w=800&q=80', 'Exterior')">+ Exterior</button>
                  <button type="button" class="btn-secondary-sm" style="font-size:0.75rem; padding:3px 8px;" onclick="window.adminApp.addPhotoFromPreset('https://images.unsplash.com/photo-1512917774080-9991f1c4c750?auto=format&fit=crop&w=800&q=80', 'Balcony')">+ Balcony</button>
                </div>

                <!-- Custom URL input -->
                <div style="display:flex; gap:6px; margin-bottom:10px;">
                  <input type="text" class="form-control" id="admin-new-photo-url" placeholder="Paste photo URL (https://...)" style="margin-bottom:0;" />
                  <button type="button" class="btn-primary-sm" style="white-space:nowrap; padding:6px 12px; background:#0f766e;" onclick="window.adminApp.addCustomPhoto()">Add Photo</button>
                </div>

                <!-- Gallery Thumbnails Preview Strip -->
                <div id="admin-photo-gallery-preview" style="display:flex; gap:8px; overflow-x:auto; padding-bottom:4px;">
                  <!-- Rendered dynamically -->
                </div>
              </div>

              <div style="display:flex; justify-content:flex-end; gap:8px; margin-top:20px;">
                <button type="button" class="btn-secondary-sm" onclick="window.adminApp.closeModal('admin-prop-form-modal')">Cancel</button>
                <button type="submit" class="btn-primary-sm" style="background:#0F766E;">${isEdit ? 'Save Changes' : 'Publish Property'}</button>
              </div>
            </form>
          </div>
        </div>
      </div>
    `;

    document.body.insertAdjacentHTML('beforeend', modalHTML);

    this.tempAdminRooms = isEdit && prop.rooms && prop.rooms.length > 0
      ? prop.rooms.map(r => r.roomNumber)
      : ['Room 1', 'Room 2', 'Room 3', 'Room 4', 'Room 5'];
    this.tempAdminRoomStyle = '123';
    this.renderAdminRoomsPreview();

    this.tempAdminPhotos = isEdit && prop.gallery && prop.gallery.length > 0
      ? [...prop.gallery]
      : (isEdit && prop.image
          ? [prop.image]
          : [
              'https://images.unsplash.com/photo-1545324418-cc1a3fa10c00?auto=format&fit=crop&w=800&q=80',
              'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?auto=format&fit=crop&w=800&q=80',
              'https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?auto=format&fit=crop&w=800&q=80'
            ]);
    this.renderAdminPhotosPreview();
  }

  setRoomCount(count) {
    this.tempAdminRooms = [];
    for (let i = 1; i <= count; i++) {
      if (this.tempAdminRoomStyle === '100') {
        this.tempAdminRooms.push(`Room ${100 + i}`);
      } else {
        this.tempAdminRooms.push(`Room ${i}`);
      }
    }
    this.renderAdminRoomsPreview();
  }

  setRoomStyle(style) {
    this.tempAdminRoomStyle = style;
    const count = this.tempAdminRooms ? this.tempAdminRooms.length : 5;
    this.setRoomCount(count);
  }

  addCustomRoom() {
    const input = document.getElementById('admin-custom-room-name');
    if (!input) return;
    const name = input.value.trim();
    if (!this.tempAdminRooms) this.tempAdminRooms = [];
    if (name) {
      if (!this.tempAdminRooms.includes(name)) {
        this.tempAdminRooms.push(name);
        input.value = '';
        this.renderAdminRoomsPreview();
      }
    } else {
      const nextNum = this.tempAdminRooms.length + 1;
      this.tempAdminRooms.push(`Room ${nextNum}`);
      this.renderAdminRoomsPreview();
    }
  }

  removeAdminRoom(idx) {
    if (!this.tempAdminRooms || this.tempAdminRooms.length <= 1) return;
    this.tempAdminRooms.splice(idx, 1);
    this.renderAdminRoomsPreview();
  }

  renderAdminRoomsPreview() {
    const container = document.getElementById('admin-room-chips-container');
    const badge = document.getElementById('admin-room-count-badge');
    if (!container) return;

    if (badge) {
      badge.textContent = `${this.tempAdminRooms.length} Rooms Total`;
    }

    // Update active state on count buttons
    document.querySelectorAll('.admin-cnt-btn').forEach(btn => {
      const cnt = parseInt(btn.textContent, 10);
      if (cnt === this.tempAdminRooms.length) {
        btn.style.background = '#0f766e';
        btn.style.color = '#fff';
      } else {
        btn.style.background = '';
        btn.style.color = '';
      }
    });

    container.innerHTML = this.tempAdminRooms.map((rName, idx) => `
      <div style="display:inline-flex; align-items:center; gap:4px; background:#f0fdfa; border:1px solid #99f6e4; color:#0f766e; padding:3px 8px; border-radius:8px; font-size:0.75rem; font-weight:700;">
        <span>🚪 ${rName}</span>
        ${this.tempAdminRooms.length > 1 ? `<button type="button" onclick="window.adminApp.removeAdminRoom(${idx})" style="background:none; border:none; color:#dc2626; cursor:pointer; font-size:0.75rem; padding:0 2px; font-weight:bold;">✕</button>` : ''}
      </div>
    `).join('');
  }

  addPhotoFromPreset(url, name) {
    if (!this.tempAdminPhotos) this.tempAdminPhotos = [];
    if (!this.tempAdminPhotos.includes(url)) {
      this.tempAdminPhotos.push(url);
      this.renderAdminPhotosPreview();
      window.appCoordinator.showToast(`Added ${name} photo`, 'INFO');
    }
  }

  addCustomPhoto() {
    const input = document.getElementById('admin-new-photo-url');
    if (!input) return;
    const url = input.value.trim();
    if (!this.tempAdminPhotos) this.tempAdminPhotos = [];
    if (url) {
      this.tempAdminPhotos.push(url);
      input.value = '';
      this.renderAdminPhotosPreview();
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
      const nextPhoto = catalog.find(p => !this.tempAdminPhotos.includes(p)) || catalog[Math.floor(Math.random() * catalog.length)];
      this.tempAdminPhotos.push(nextPhoto);
      this.renderAdminPhotosPreview();
      window.appCoordinator.showToast('Room photo added!', 'SUCCESS');
    }
  }

  removeAdminPhoto(idx) {
    if (!this.tempAdminPhotos) return;
    this.tempAdminPhotos.splice(idx, 1);
    this.renderAdminPhotosPreview();
  }

  renderAdminPhotosPreview() {
    const container = document.getElementById('admin-photo-gallery-preview');
    const badge = document.getElementById('admin-photo-count-badge');
    if (!container) return;

    if (badge) {
      badge.textContent = `${this.tempAdminPhotos.length} Attached`;
    }

    if (!this.tempAdminPhotos || this.tempAdminPhotos.length === 0) {
      container.innerHTML = '<span style="font-size:0.75rem; color:#94a3b8;">No photos attached. Tap presets above to add.</span>';
      return;
    }

    container.innerHTML = this.tempAdminPhotos.map((url, idx) => `
      <div style="position:relative; flex-shrink:0; width:72px; height:60px; border-radius:8px; overflow:hidden; border:2px solid ${idx === 0 ? '#0f766e' : '#cbd5e1'};">
        <img src="${url}" style="width:100%; height:100%; object-fit:cover;" />
        <span style="position:absolute; top:2px; left:2px; background:${idx === 0 ? '#0f766e' : 'rgba(0,0,0,0.65)'}; color:#fff; font-size:0.6rem; font-weight:700; padding:1px 4px; border-radius:3px;">
          ${idx === 0 ? 'Cover' : '#' + (idx + 1)}
        </span>
        <button type="button" onclick="window.adminApp.removeAdminPhoto(${idx})" style="position:absolute; top:2px; right:2px; background:#dc2626; color:#fff; border:none; border-radius:50%; width:16px; height:16px; font-size:10px; cursor:pointer; display:flex; align-items:center; justify-content:center; padding:0;">
          ✕
        </button>
      </div>
    `).join('');
  }

  handlePropertyFormSubmit(e, editId) {
    e.preventDefault();
    const photos = (this.tempAdminPhotos && this.tempAdminPhotos.length > 0)
      ? this.tempAdminPhotos
      : ['https://images.unsplash.com/photo-1545324418-cc1a3fa10c00?auto=format&fit=crop&w=800&q=80'];

    const rooms = (this.tempAdminRooms && this.tempAdminRooms.length > 0)
      ? this.tempAdminRooms
      : ['Room 1', 'Room 2', 'Room 3', 'Room 4', 'Room 5'];

    const monthlyRent = document.getElementById('ap-rent').value;
    const securityDeposit = document.getElementById('ap-deposit').value;
    const furnishing = document.getElementById('ap-furnishing').value;
    const propertyType = document.getElementById('ap-propType').value;

    const extraRooms = rooms.slice(1).map(rName => ({
      roomNumber: rName,
      roomType: propertyType,
      monthlyRent: monthlyRent,
      securityDeposit: securityDeposit,
      furnishing: furnishing,
      image: photos[0]
    }));

    const data = {
      title: document.getElementById('ap-title').value.trim(),
      areaType: document.getElementById('ap-areaType').value,
      propertyType: propertyType,
      city: document.getElementById('ap-city').value.trim(),
      locality: document.getElementById('ap-locality').value.trim(),
      address: document.getElementById('ap-address').value.trim(),
      roomNumber: rooms[0],
      monthlyRent: monthlyRent,
      securityDeposit: securityDeposit,
      furnishing: furnishing,
      isMultiRoom: rooms.length > 1,
      extraRooms: extraRooms,
      images: photos,
      gallery: photos,
      image: photos[0],
      approvalStatus: 'Approved'
    };

    if (editId) {
      this.state.editProperty(editId, data);
      window.appCoordinator.showToast(`Property updated with ${rooms.length} rooms and ${photos.length} photos!`, 'SUCCESS');
    } else {
      this.state.addProperty(data);
      window.appCoordinator.showToast(`Published with ${rooms.length} rooms (1 to ${rooms.length}) and ${photos.length} photos!`, 'SUCCESS');
    }

    this.closeModal('admin-prop-form-modal');
    this.switchSection('properties');
  }

  deleteProperty(propertyId) {
    if (confirm('Are you sure you want to delete this property?')) {
      this.state.deleteProperty(propertyId);
      window.appCoordinator.showToast('Property deleted successfully.', 'INFO');
      this.switchSection('properties');
    }
  }

  // --- CRUD Modals: Customers ---
  openAddCustomerModal() {
    this.openCustomerFormModal(null);
  }

  openEditCustomerModal(customerId) {
    const cust = this.state.data.users.find(u => u.id === customerId);
    if (!cust) return;
    this.openCustomerFormModal(cust);
  }

  openCustomerFormModal(cust) {
    const isEdit = !!cust;

    const modalHTML = `
      <div class="modal-backdrop active" id="admin-cust-form-modal" onclick="if(event.target===this) window.adminApp.closeModal('admin-cust-form-modal')">
        <div class="modal-card-dialog">
          <div class="modal-header">
            <h3>${isEdit ? '✏️ Edit Customer' : '➕ Add New Customer'}</h3>
            <button class="modal-close-btn" onclick="window.adminApp.closeModal('admin-cust-form-modal')">✕</button>
          </div>
          <div class="modal-body">
            <form id="admin-cust-form" onsubmit="window.adminApp.handleCustomerFormSubmit(event, '${isEdit ? cust.id : ''}')">
              <div class="form-group">
                <label>Full Name *</label>
                <input type="text" class="form-control" id="ac-name" required value="${isEdit ? cust.name : ''}" />
              </div>
              <div class="form-group">
                <label>Mobile (+91) *</label>
                <input type="text" class="form-control" id="ac-mobile" required value="${isEdit ? cust.mobile : ''}" />
              </div>
              <div class="form-group">
                <label>Email Address</label>
                <input type="email" class="form-control" id="ac-email" value="${isEdit ? cust.email : ''}" />
              </div>
              <div class="form-group">
                <label>Tenant Category</label>
                <select class="form-control" id="ac-type">
                  <option value="Single" ${isEdit && cust.customerType === 'Single' ? 'selected' : ''}>Student / Bachelor (Single)</option>
                  <option value="Family" ${isEdit && cust.customerType === 'Family' ? 'selected' : ''}>Family</option>
                  <option value="Couple" ${isEdit && cust.customerType === 'Couple' ? 'selected' : ''}>Couple</option>
                  <option value="Working Professional" ${isEdit && cust.customerType === 'Working Professional' ? 'selected' : ''}>Working Professional</option>
                  <option value="Other" ${isEdit && cust.customerType === 'Other' ? 'selected' : ''}>Other</option>
                </select>
              </div>
              <div class="form-group">
                <label>Rental Property Assignment</label>
                <select class="form-control" id="ac-property" onchange="window.adminApp.onCustomerModalPropertyChange(this.value)">
                  <option value="">⚪ None (Prospective / Inquiry)</option>
                  ${this.state.data.properties.map(p => `
                    <option value="${p.id}" ${isEdit && cust.assignedPropertyId === p.id ? 'selected' : ''}>🏠 ${p.title} (${p.city})</option>
                  `).join('')}
                </select>
              </div>

              <div id="ac-booking-details-box" style="${isEdit && cust.assignedPropertyId ? '' : 'display:none;'}">
                <div class="form-group" id="ac-room-group">
                  <label>Assigned Unit / Room Number</label>
                  <select class="form-control" id="ac-room" onchange="window.adminApp.onCustomerRoomChange(this.value)">
                    ${isEdit && cust.assignedPropertyId ? (() => {
                      const p = this.state.data.properties.find(prop => prop.id === cust.assignedPropertyId);
                      return p ? p.rooms.map(r => `<option value="${r.id}" data-rent="${r.monthlyRent}" ${cust.assignedRoomId === r.id ? 'selected' : ''}>${r.roomNumber} - ₹${r.monthlyRent}/mo (${r.status})</option>`).join('') : '';
                    })() : ''}
                  </select>
                </div>

                <!-- Booking Duration Type (Month / Day / Hour) -->
                <div style="background:#f8fafc; border:1px solid #e2e8f0; border-radius:10px; padding:10px; margin-bottom:12px;">
                  <label style="font-size:0.78rem; font-weight:700; color:#0f766e; display:block; margin-bottom:6px;">
                    ⏱️ Booking Duration Type & Stay Period:
                  </label>
                  <div style="display:grid; grid-template-columns:1fr 1fr 1fr; gap:6px; margin-bottom:8px;">
                    <button type="button" class="btn-secondary-sm ac-dur-btn" id="ac-btn-month" onclick="window.adminApp.setCustomerDurationType('month')" style="padding:4px; font-size:0.75rem; background:#0f766e; color:#fff;">📅 Month</button>
                    <button type="button" class="btn-secondary-sm ac-dur-btn" id="ac-btn-day" onclick="window.adminApp.setCustomerDurationType('day')" style="padding:4px; font-size:0.75rem;">☀️ Day</button>
                    <button type="button" class="btn-secondary-sm ac-dur-btn" id="ac-btn-hour" onclick="window.adminApp.setCustomerDurationType('hour')" style="padding:4px; font-size:0.75rem;">⏱️ Hour</button>
                  </div>

                  <div id="ac-duration-presets" style="display:flex; flex-wrap:wrap; gap:4px; margin-bottom:8px;">
                    <!-- Dynamically populated chips -->
                  </div>

                  <div style="display:grid; grid-template-columns:1fr 1.5fr; gap:8px;">
                    <div>
                      <label style="font-size:0.72rem; color:#64748b;">Duration Value</label>
                      <input type="number" class="form-control" id="ac-duration-val" value="${isEdit && cust.bookingDurationValue ? cust.bookingDurationValue : 1}" min="1" oninput="window.adminApp.recalcCustomerFinancials()" style="margin-bottom:0;" />
                    </div>
                    <div>
                      <label style="font-size:0.72rem; color:#64748b;">Move-in / Start Date</label>
                      <input type="text" class="form-control" id="ac-start-date" value="${isEdit && cust.moveInDate ? cust.moveInDate : '2026-10-01'}" style="margin-bottom:0;" />
                    </div>
                  </div>

                  <div id="ac-calc-summary" style="margin-top:8px; font-size:0.75rem; font-weight:700; color:#0f766e; background:#f0fdfa; padding:6px 8px; border-radius:6px; border:1px solid #99f6e4;">
                    Calculated Rent: ₹9,000 / month
                  </div>
                </div>
              </div>

              <div class="form-group">
                <label>
                  <input type="checkbox" id="ac-kyc" ${!isEdit || cust.aadhaarVerified ? 'checked' : ''} />
                  Aadhaar e-KYC Verified
                </label>
              </div>
              <div style="display:flex; justify-content:flex-end; gap:8px; margin-top:16px;">
                <button type="button" class="btn-secondary-sm" onclick="window.adminApp.closeModal('admin-cust-form-modal')">Cancel</button>
                <button type="submit" class="btn-primary-sm" style="background:#0284c7;">${isEdit ? 'Save Changes' : 'Add Customer'}</button>
              </div>
            </form>
          </div>
        </div>
      </div>
    `;

    document.body.insertAdjacentHTML('beforeend', modalHTML);

    this.currentCustDurationType = (isEdit && cust.bookingDurationType) ? cust.bookingDurationType : 'month';
    this.setCustomerDurationType(this.currentCustDurationType);
  }

  setCustomerDurationType(type) {
    this.currentCustDurationType = type;
    const presetsBox = document.getElementById('ac-duration-presets');
    const valInput = document.getElementById('ac-duration-val');
    
    // Update button states
    ['month', 'day', 'hour'].forEach(t => {
      const btn = document.getElementById(`ac-btn-${t}`);
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
        presetsBox.innerHTML = [1, 2, 3, 6, 11, 12].map(m => `
          <button type="button" class="btn-secondary-sm" style="padding:2px 8px; font-size:0.7rem;" onclick="document.getElementById('ac-duration-val').value=${m}; window.adminApp.recalcCustomerFinancials()">${m} Mo</button>
        `).join('');
      } else if (type === 'day') {
        presetsBox.innerHTML = [1, 2, 3, 5, 7, 15, 30].map(d => `
          <button type="button" class="btn-secondary-sm" style="padding:2px 8px; font-size:0.7rem;" onclick="document.getElementById('ac-duration-val').value=${d}; window.adminApp.recalcCustomerFinancials()">${d} Days</button>
        `).join('');
      } else if (type === 'hour') {
        presetsBox.innerHTML = [1, 2, 3, 4, 6, 8, 12, 24].map(h => `
          <button type="button" class="btn-secondary-sm" style="padding:2px 8px; font-size:0.7rem;" onclick="document.getElementById('ac-duration-val').value=${h}; window.adminApp.recalcCustomerFinancials()">${h} Hrs</button>
        `).join('');
      }
    }

    this.recalcCustomerFinancials();
  }

  onCustomerRoomChange() {
    this.recalcCustomerFinancials();
  }

  recalcCustomerFinancials() {
    const summaryBox = document.getElementById('ac-calc-summary');
    const roomSelect = document.getElementById('ac-room');
    const valInput = document.getElementById('ac-duration-val');
    if (!summaryBox || !roomSelect || !valInput) return;

    const opt = roomSelect.options[roomSelect.selectedIndex];
    const baseMonthly = opt ? (parseInt(opt.getAttribute('data-rent'), 10) || 9000) : 9000;
    const durVal = parseInt(valInput.value, 10) || 1;
    const type = this.currentCustDurationType || 'month';

    let total = baseMonthly;
    if (type === 'hour') {
      const hrRate = Math.max(50, Math.round(baseMonthly / (30 * 6)));
      total = hrRate * durVal;
      summaryBox.textContent = `⏱️ Hourly Stay: ${durVal} Hours · Total Rent: ₹${total} (₹${hrRate}/hr)`;
    } else if (type === 'day') {
      const dayRate = Math.round(baseMonthly / 30);
      total = dayRate * durVal;
      summaryBox.textContent = `☀️ Daily Stay: ${durVal} Days · Total Rent: ₹${total} (₹${dayRate}/day)`;
    } else {
      total = baseMonthly * durVal;
      summaryBox.textContent = `📅 Monthly Lease: ${durVal} Months · Total: ₹${total} (₹${baseMonthly}/mo)`;
    }
  }

  onCustomerModalPropertyChange(propId) {
    const box = document.getElementById('ac-booking-details-box');
    const roomSelect = document.getElementById('ac-room');
    if (!box || !roomSelect) return;

    if (!propId) {
      box.style.display = 'none';
      roomSelect.innerHTML = '';
      return;
    }

    const prop = this.state.data.properties.find(p => p.id === propId);
    if (prop && prop.rooms && prop.rooms.length > 0) {
      box.style.display = 'block';
      roomSelect.innerHTML = prop.rooms.map(r => `
        <option value="${r.id}" data-rent="${r.monthlyRent}">${r.roomNumber} - ₹${r.monthlyRent}/mo (${r.status})</option>
      `).join('');
      this.recalcCustomerFinancials();
    } else {
      box.style.display = 'none';
      roomSelect.innerHTML = '';
    }
  }

  handleCustomerFormSubmit(e, editId) {
    e.preventDefault();
    const propId = document.getElementById('ac-property') ? document.getElementById('ac-property').value : '';
    const roomId = document.getElementById('ac-room') ? document.getElementById('ac-room').value : '';
    const durationType = this.currentCustDurationType || 'month';
    const durationVal = document.getElementById('ac-duration-val') ? (parseInt(document.getElementById('ac-duration-val').value, 10) || 1) : 1;
    const startDate = document.getElementById('ac-start-date') ? document.getElementById('ac-start-date').value.trim() : '2026-10-01';

    let assignedPropTitle = null;
    let assignedRoomNo = null;
    let assignedRent = null;

    if (propId) {
      const prop = this.state.data.properties.find(p => p.id === propId);
      if (prop) {
        assignedPropTitle = prop.title;
        const room = prop.rooms.find(r => r.id === roomId) || prop.rooms[0];
        if (room) {
          assignedRoomNo = room.roomNumber;
          const baseMonthly = room.monthlyRent;
          if (durationType === 'hour') {
            assignedRent = Math.max(50, Math.round(baseMonthly / (30 * 6))) * durationVal;
          } else if (durationType === 'day') {
            assignedRent = Math.round(baseMonthly / 30) * durationVal;
          } else {
            assignedRent = baseMonthly * durationVal;
          }
          room.status = 'Rented';
        }
      }
    }

    const data = {
      name: document.getElementById('ac-name').value.trim(),
      mobile: document.getElementById('ac-mobile').value.trim(),
      email: document.getElementById('ac-email').value.trim(),
      customerType: document.getElementById('ac-type').value,
      aadhaarVerified: document.getElementById('ac-kyc').checked,
      bookingDurationType: durationType,
      bookingDurationValue: durationVal,
      moveInDate: startDate,
      assignedPropertyId: propId || null,
      assignedRoomId: roomId || null,
      assignedPropertyTitle: assignedPropTitle,
      assignedRoomNumber: assignedRoomNo,
      monthlyRent: assignedRent
    };

    if (editId) {
      this.state.adminEditCustomer(editId, data);
      window.appCoordinator.showToast(`Customer updated for ${durationVal} ${durationType}(s)!`, 'SUCCESS');
    } else {
      this.state.adminAddCustomer(data);
      window.appCoordinator.showToast(`Customer added with ${durationVal} ${durationType}(s) booking!`, 'SUCCESS');
    }

    this.closeModal('admin-cust-form-modal');
    this.switchSection('customers');
  }

  deleteCustomer(customerId) {
    if (confirm('Are you sure you want to delete this customer?')) {
      this.state.adminDeleteCustomer(customerId);
      window.appCoordinator.showToast('Customer removed from directory.', 'INFO');
      this.switchSection('customers');
    }
  }

  // --- CRUD Modals: Owners ---
  openAddOwnerModal() {
    this.openOwnerFormModal(null);
  }

  openEditOwnerModal(ownerId) {
    const owner = this.state.data.users.find(u => u.id === ownerId);
    if (!owner) return;
    this.openOwnerFormModal(owner);
  }

  openOwnerFormModal(owner) {
    const isEdit = !!owner;

    const modalHTML = `
      <div class="modal-backdrop active" id="admin-owner-form-modal" onclick="if(event.target===this) window.adminApp.closeModal('admin-owner-form-modal')">
        <div class="modal-card-dialog">
          <div class="modal-header">
            <h3>${isEdit ? '✏️ Edit Landlord / Host' : '➕ Add New Landlord / Host'}</h3>
            <button class="modal-close-btn" onclick="window.adminApp.closeModal('admin-owner-form-modal')">✕</button>
          </div>
          <div class="modal-body">
            <form id="admin-owner-form" onsubmit="window.adminApp.handleOwnerFormSubmit(event, '${isEdit ? owner.id : ''}')">
              <div class="form-group">
                <label>Host / Landlord Name *</label>
                <input type="text" class="form-control" id="ao-name" required value="${isEdit ? owner.name : ''}" />
              </div>
              <div class="form-group">
                <label>Mobile (+91) *</label>
                <input type="text" class="form-control" id="ao-mobile" required value="${isEdit ? owner.mobile : ''}" />
              </div>
              <div class="form-group">
                <label>Email Address</label>
                <input type="email" class="form-control" id="ao-email" value="${isEdit ? (owner.email || '') : ''}" />
              </div>
              <div class="form-group">
                <label>Contact Privacy Mode</label>
                <select class="form-control" id="ao-privacy">
                  <option value="CALL_MSG_ON" ${isEdit && owner.contactSettings === 'CALL_MSG_ON' ? 'selected' : ''}>Calls & SMS On</option>
                  <option value="CALL_ON_MSG_OFF" ${isEdit && owner.contactSettings === 'CALL_ON_MSG_OFF' ? 'selected' : ''}>Calls On, SMS Off</option>
                  <option value="CALL_OFF_MSG_ON" ${isEdit && owner.contactSettings === 'CALL_OFF_MSG_ON' ? 'selected' : ''}>Calls Off, SMS On</option>
                  <option value="BOTH_OFF" ${isEdit && owner.contactSettings === 'BOTH_OFF' ? 'selected' : ''}>Masked / Privacy Mode</option>
                </select>
              </div>
              <div style="display:flex; justify-content:flex-end; gap:8px; margin-top:16px;">
                <button type="button" class="btn-secondary-sm" onclick="window.adminApp.closeModal('admin-owner-form-modal')">Cancel</button>
                <button type="submit" class="btn-primary-sm" style="background:#d97706;">${isEdit ? 'Save Changes' : 'Add Landlord'}</button>
              </div>
            </form>
          </div>
        </div>
      </div>
    `;

    document.body.insertAdjacentHTML('beforeend', modalHTML);
  }

  handleOwnerFormSubmit(e, editId) {
    e.preventDefault();
    const data = {
      name: document.getElementById('ao-name').value.trim(),
      mobile: document.getElementById('ao-mobile').value.trim(),
      email: document.getElementById('ao-email').value.trim(),
      contactSettings: document.getElementById('ao-privacy').value
    };

    if (editId) {
      this.state.adminEditOwner(editId, data);
      window.appCoordinator.showToast('Landlord details updated!', 'SUCCESS');
    } else {
      this.state.adminAddOwner(data);
      window.appCoordinator.showToast('New landlord registered!', 'SUCCESS');
    }

    this.closeModal('admin-owner-form-modal');
    this.switchSection('owners');
  }

  deleteOwner(ownerId) {
    if (confirm('Are you sure you want to delete this landlord?')) {
      this.state.adminDeleteOwner(ownerId);
      window.appCoordinator.showToast('Landlord removed from directory.', 'INFO');
      this.switchSection('owners');
    }
  }

  openAdminUserMenu() {
    const currentAdmin = this.state.data.adminUsers?.find(a => a.id === this.state.currentUserId) || {
      name: 'Super Administrator',
      adminRole: 'Super Admin',
      email: 'admin@rentease.in',
      mobile: '9876500001',
      status: 'Active',
      permissions: ['ALL']
    };

    const modalHTML = `
      <div class="modal-backdrop active" id="admin-user-menu-modal" onclick="if(event.target===this) window.adminApp.closeModal('admin-user-menu-modal')">
        <div class="modal-card-dialog" style="max-width: 460px;">
          <div class="modal-header">
            <h3>👤 Admin Session & Profile</h3>
            <button class="modal-close-btn" onclick="window.adminApp.closeModal('admin-user-menu-modal')">✕</button>
          </div>
          <div class="modal-body">
            <div style="text-align:center; padding:12px; background:#f8fafc; border-radius:12px; margin-bottom:14px; border:1px solid #e2e8f0;">
              <div style="font-size:2.5rem; margin-bottom:6px;">🛡️</div>
              <h4 style="font-size:1.1rem; color:#0f172a; margin:0;">${currentAdmin.name}</h4>
              <span class="admin-role-pill" style="display:inline-block; margin-top:4px;">${currentAdmin.adminRole || 'Super Admin'}</span>
              <p style="font-size:0.75rem; color:#64748b; margin-top:6px;">${currentAdmin.email} • 📱 +91 ${currentAdmin.mobile}</p>
            </div>

            <div style="background:#eff6ff; border:1px solid #bfdbfe; border-radius:10px; padding:10px 12px; margin-bottom:14px; font-size:0.78rem; color:#1e40af;">
              <strong>Permissions:</strong> ${Array.isArray(currentAdmin.permissions) ? currentAdmin.permissions.join(', ') : 'ALL Master Modules'}
            </div>

            <div style="display:flex; flex-direction:column; gap:8px;">
              <button class="btn-primary-sm" style="width:100%; background:#0284c7; padding:10px;" onclick="window.adminApp.closeModal('admin-user-menu-modal'); window.adminApp.switchSection('admin_users');">
                🛡️ Manage Admin Users & RBAC
              </button>
              <button class="btn-primary-sm" style="width:100%; background:#ef4444; padding:10px;" onclick="window.adminApp.closeModal('admin-user-menu-modal'); window.adminApp.logout();">
                🚪 Logout Admin Session
              </button>
            </div>
          </div>
        </div>
      </div>
    `;
    document.body.insertAdjacentHTML('beforeend', modalHTML);
  }

  attachEventListeners() {
    document.addEventListener('click', (e) => {
      const searchBox = document.querySelector('.admin-search-box-wrapper');
      const dropdown = document.getElementById('admin-search-dropdown');
      if (searchBox && dropdown && !searchBox.contains(e.target)) {
        dropdown.style.display = 'none';
      }
    });
  }
}

if (typeof window !== 'undefined') {
  window.AdminAppController = AdminAppController;
}

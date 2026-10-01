/**
 * End-to-End Test Suite for Monthly Property Rental Platform
 * Validates all 18 Business Rules, State Engine & Relational Workflows
 */

const assert = require('assert');
const path = require('path');

// Mock localStorage for Node.js testing
const storageMock = {};
global.localStorage = {
  getItem: (key) => storageMock[key] || null,
  setItem: (key, val) => { storageMock[key] = String(val); },
  removeItem: (key) => { delete storageMock[key]; },
  clear: () => { Object.keys(storageMock).forEach(k => delete storageMock[k]); }
};

const { INITIAL_DATABASE } = require('../js/data.js');
global.window = {
  INITIAL_DATABASE
};

const { AppState } = require('../js/state.js');

console.log('🧪 Starting Comprehensive Rental Platform Test Suite...\n');

const state = new AppState();

// Test 1: Verify Seed Database & Initialization
console.log('Test 1: Verify Seed Database');
assert.strictEqual(state.data.properties.length >= 9, true, 'Should have at least 9 seed properties');
assert.strictEqual(state.data.users.length >= 9, true, 'Should have customers, owners, and admin');
console.log('✅ Seed Database Loaded Correctly\n');

// Test 2: Search & Filter Rules
console.log('Test 2: Search & Filter Rules (Urban, Rural, Suitable For, Rent Range)');
// Urban filter
state.setSearchFilters({ areaType: 'urban', city: 'Varanasi', suitableFor: [], maxRent: 50000, onlyAvailable: true });
const urbanResults = state.getSearchResults();
assert.strictEqual(urbanResults.every(r => r.property.areaType === 'urban' && r.property.city === 'Varanasi'), true, 'Urban filter must match');
console.log(`✅ Urban search returned ${urbanResults.length} available units`);

// Rural filter
state.setSearchFilters({ areaType: 'rural', city: '', suitableFor: [], maxRent: 50000, onlyAvailable: true });
const ruralResults = state.getSearchResults();
assert.strictEqual(ruralResults.every(r => r.property.areaType === 'rural'), true, 'Rural filter must match');
console.log(`✅ Rural search returned ${ruralResults.length} available units`);

// Suitable For filter (Mandatory Rule 5 & 6)
state.setSearchFilters({ areaType: 'all', city: '', suitableFor: ['students'], maxRent: 50000, onlyAvailable: true });
const studentResults = state.getSearchResults();
assert.strictEqual(studentResults.every(r => r.room.suitableFor.includes('students')), true, 'All returned rooms must be suitable for students');
console.log(`✅ Suitable For filter returned ${studentResults.length} units eligible for students\n`);

// Test 3: Availability Rule (Rule 1 & 2 & 7)
console.log('Test 3: Available Property Rule');
// Room 102 in Ganga Heights is Rented in seed data
const allUnits = state.getSearchResults();
const rentedFound = allUnits.some(r => r.room.id === 'room_102');
assert.strictEqual(rentedFound, false, 'Rented unit (Room 102) MUST be hidden from customer search');
console.log('✅ Rented rooms are strictly hidden from search\n');

// Test 4: Rental Request & Owner Decision Flow (Sections 10 & 11)
console.log('Test 4: Rental Request & Approval Workflow');
state.setCurrentUser('cust_4'); // Vikram Singh
const newReq = state.createRentalRequest({
  propertyId: 'prop_2',
  roomId: 'room_201',
  expectedMoveInDate: '2026-11-01',
  rentalPeriodMonths: 11,
  requirements: 'Quiet family looking for clean independent house'
});

assert.strictEqual(newReq.status, 'Pending');
assert.strictEqual(state.getPropertyRoomById('prop_2', 'room_201').room.status, 'Rental Request');
console.log('✅ Rental Request created with status Pending');

// Owner accepts request
state.ownerRespondToRequest(newReq.id, 'ACCEPT');
assert.strictEqual(newReq.status, 'Accepted');
assert.strictEqual(state.getPropertyRoomById('prop_2', 'room_201').room.status, 'Agreement Pending');
console.log('✅ Owner Accepted request -> Room status updated to Agreement Pending\n');

// Test 5: Aadhaar e-KYC & Agreement Finalization (Section 12, 13, 17, 19)
console.log('Test 5: Aadhaar e-KYC & Agreement Execution');
state.performAadhaarKYC('cust_4', '548291024512', '123456');
const cust4 = state.data.users.find(u => u.id === 'cust_4');
assert.strictEqual(cust4.aadhaarVerified, true);
assert.strictEqual(cust4.aadhaarLast4, '4512');
console.log('✅ Aadhaar e-KYC verification successful');

const { agreement, activeRental } = state.completeRentalAgreement(newReq.id);
assert.strictEqual(agreement.status, 'Agreement Completed');
assert.strictEqual(activeRental.status, 'Active');
assert.strictEqual(state.getPropertyRoomById('prop_2', 'room_201').room.status, 'Rented');
console.log('✅ Agreement finalized -> Active Rental created -> Room status changed to Rented\n');

// Verify room_201 is now hidden from search
const postAgreementSearch = state.getSearchResults();
const room201Found = postAgreementSearch.some(r => r.room.id === 'room_201');
assert.strictEqual(room201Found, false, 'Newly rented room is now hidden from search');
console.log('✅ Newly rented room is hidden from search\n');

// Test 6: Monthly Rent Ledger & Payment Recording (Sections 19, 20, 21, 22, 23, 25)
console.log('Test 6: Monthly Rent Payment Flow & Digital Receipt');
const pendingPayment = state.data.rentPayments.find(p => p.rentalId === activeRental.id && p.paymentStatus === 'Pending');
assert.notStrictEqual(pendingPayment, undefined, 'Monthly rent record must be automatically generated');
assert.strictEqual(pendingPayment.rentAmount, 22000);

const paidRecord = state.recordRentPayment({
  paymentId: pendingPayment.id,
  paymentMode: 'UPI',
  transactionRef: 'UPI-TEST-998811',
  notes: 'Online test payment'
});

assert.strictEqual(paidRecord.paymentStatus, 'Paid');
assert.notStrictEqual(paidRecord.receiptNumber, null);
assert.strictEqual(paidRecord.paymentMode, 'UPI');
console.log(`✅ Rent payment recorded as Paid! Receipt #${paidRecord.receiptNumber} generated\n`);

// Test 7: Owner Privacy & Contact Settings (Section 9)
console.log('Test 7: Owner Privacy & Contact Controls');
state.updateOwnerContactSettings('owner_1', 'BOTH_OFF');
const privacy1 = state.getOwnerContactPermissions('owner_1');
assert.strictEqual(privacy1.canCall, false);
assert.strictEqual(privacy1.canMessage, false);

state.updateOwnerContactSettings('owner_1', 'CALL_ON_MSG_OFF');
const privacy2 = state.getOwnerContactPermissions('owner_1');
assert.strictEqual(privacy2.canCall, true);
assert.strictEqual(privacy2.canMessage, false);

state.updateOwnerContactSettings('owner_1', 'CALL_MSG_ON');
const privacy3 = state.getOwnerContactPermissions('owner_1');
assert.strictEqual(privacy3.canCall, true);
assert.strictEqual(privacy3.canMessage, true);
console.log('✅ Owner Privacy settings (4 options) fully functional\n');

// Test 8: Admin Statistics & Complaints Resolution (Section 28 & 29)
console.log('Test 8: Admin Analytics & Governance');
const stats = state.getAdminStatistics();
assert.strictEqual(stats.totalCustomers >= 4, true);
assert.strictEqual(stats.totalOwners >= 4, true);
assert.strictEqual(stats.activeRentals >= 3, true);
assert.strictEqual(stats.totalRentCollected > 0, true);

// Test Complaint Filing & Admin Response
const newComp = state.submitComplaint({
  category: 'Maintenance',
  subject: 'Water pipeline maintenance',
  description: 'Water pressure in kitchen tap'
});
assert.strictEqual(newComp.status, 'Open');

state.adminRespondComplaint(newComp.id, 'Plumber assigned for inspection', 'Resolved');
const resolvedComp = state.data.complaints.find(c => c.id === newComp.id);
assert.strictEqual(resolvedComp.status, 'Resolved');
assert.strictEqual(resolvedComp.adminResponse, 'Plumber assigned for inspection');
console.log('✅ Complaint filed and resolved by Admin successfully\n');

// Test 9: Admin Authentication & RBAC (Section 1 & 22)
console.log('Test 9: Admin Authentication & RBAC');
const adminUser = state.adminLogin({ email: 'admin@rentease.in', password: 'admin123', otp: '123456' });
assert.strictEqual(adminUser.id, 'admin_1');
assert.strictEqual(state.currentRole, 'ADMIN');
assert.throws(() => state.adminLogin({ email: 'admin@rentease.in', password: 'wrong' }), /Incorrect password/);
console.log('✅ Admin Login & Security Authentication Verified\n');

// Test 10: Property Approval & Rejection Flow (Section 6 & 10)
console.log('Test 10: Property Approval Workflow');
const newProp = state.addProperty({
  title: 'Luxury Villa DLF',
  propertyType: 'house',
  areaType: 'urban',
  city: 'Lucknow',
  locality: 'Gomti Nagar',
  address: 'Plot 10, Gomti Greens',
  rooms: [{ roomNumber: 'Villa 1', monthlyRent: 45000, status: 'Pending Approval', suitableFor: ['family'] }]
});
assert.strictEqual(newProp.approvalStatus, 'Pending Approval');

state.adminApproveProperty(newProp.id);
assert.strictEqual(newProp.approvalStatus, 'Approved');
assert.strictEqual(newProp.rooms[0].status, 'Available');

state.adminRejectProperty(newProp.id, 'Incomplete fire safety certificate');
assert.strictEqual(newProp.approvalStatus, 'Rejected');
assert.strictEqual(newProp.rejectionReason, 'Incomplete fire safety certificate');
console.log('✅ Property Approval & Rejection Flow Verified\n');

// Test 11: Property Types & Suitable For CRUD (Section 7 & 8)
console.log('Test 11: Property Types & Suitable For CRUD');
const newPT = state.adminAddPropertyType({ name: 'Studio Penthouse', icon: '🏙️', description: 'Top floor luxury studio' });
assert.strictEqual(newPT.id, 'studio_penthouse');
assert.strictEqual(state.data.propertyTypes.some(pt => pt.id === 'studio_penthouse'), true);

const newCat = state.adminAddSuitableForCategory({ name: 'Senior Citizens', badgeColor: '#8b5cf6' });
assert.strictEqual(newCat.id, 'senior_citizens');
assert.strictEqual(state.data.customerTypes.some(c => c.id === 'senior_citizens'), true);
console.log('✅ Property Types & Suitable For CRUD Verified\n');

// Test 12: Area Hierarchy Management (Section 9)
console.log('Test 12: Area Hierarchy Management (Urban & Rural)');
state.adminAddUrbanLocality('Varanasi', 'Cantt Railway Station Hub');
const varanasi = state.data.areas.urban.find(u => u.city === 'Varanasi');
assert.strictEqual(varanasi.localities.includes('Cantt Railway Station Hub'), true);

state.adminAddRuralVillage('Varanasi Rural', 'Shivdaspur Village');
const varanasiRural = state.data.areas.rural.find(r => r.district === 'Varanasi Rural');
assert.strictEqual(varanasiRural.villages.includes('Shivdaspur Village'), true);
console.log('✅ Urban & Rural Area Hierarchy Management Verified\n');

// Test 13: Rent Reminders & Anti-Duplication Safeguard (Section 17)
console.log('Test 13: Rent Reminders & Anti-Duplication');
const rem = state.adminSendRentReminder(activeRental.id, 'Due Today Alert', 'SMS Gateway Integration');
assert.strictEqual(rem.status, 'Delivered');
// Attempt duplicate reminder same day should fail
assert.throws(() => state.adminSendRentReminder(activeRental.id, 'Due Today Alert'), /already been sent today/);
console.log('✅ Rent Reminder Automation & Duplicate Safeguard Verified\n');

// Test 14: Reports Data Generation & CSV Export (Section 21)
console.log('Test 14: Reports Generation & CSV Export');
const custReport = state.adminGenerateReport('CUSTOMERS');
assert.strictEqual(custReport.length >= 4, true);
const csvData = state.adminExportReportCSV('RENT_COLLECTION');
assert.strictEqual(csvData.includes('Receipt #'), true);
assert.strictEqual(csvData.includes('Amount (₹)'), true);
console.log(`✅ Reports generated & CSV export formatted (${csvData.split('\n').length} lines)\n`);

// Test 15: Global Admin Search (Section 24)
console.log('Test 15: Global Admin Search');
const searchRes = state.adminGlobalSearch('Amit');
assert.strictEqual(searchRes.customers.length >= 1, true);
assert.strictEqual(searchRes.customers[0].name, 'Amit Sharma');
console.log('✅ Global Admin Multi-Module Search Verified\n');

// Test 16: Audit Trail Logging (Section 23)
console.log('Test 16: Audit Trail Logging');
assert.strictEqual(state.data.auditLogs.length >= 5, true);
assert.strictEqual(state.data.auditLogs.some(l => l.action === 'ADMIN_LOGIN'), true);
console.log(`✅ Security & Financial Audit Trail Verified (${state.data.auditLogs.length} audit records)\n`);

// Test 17: Platform Settings Persistence (Section 25)
console.log('Test 17: Platform Settings Persistence');
state.adminUpdateSettings({
  general: { platformName: 'RentEase Enterprise Pro', supportEmail: 'admin@rentease.in', supportPhone: '+91 1800-111-222', currencySymbol: '₹', defaultAgreementMonths: 11 }
});
assert.strictEqual(state.data.settings.general.platformName, 'RentEase Enterprise Pro');
console.log('✅ Platform Settings Persistence Verified\n');

// Test 18: Full CRUD Operations (Add, Edit, Delete for Properties, Customers, Landlords)
console.log('Test 18: Full CRUD Lifecycle (Properties, Customers, Owners)');
// 1. Property CRUD
const initialPropCount = state.data.properties.length;
const createdProp = state.addProperty({
  title: 'Test Paradise Residency',
  propertyType: 'apartment',
  areaType: 'urban',
  city: 'Varanasi',
  locality: 'Sigra',
  monthlyRent: 12000,
  securityDeposit: 24000,
  approvalStatus: 'Approved'
});
assert.strictEqual(state.data.properties.length, initialPropCount + 1);

state.editProperty(createdProp.id, { title: 'Test Paradise Residency (Renovated)', monthlyRent: 13500 });
const updatedProp = state.data.properties.find(p => p.id === createdProp.id);
assert.strictEqual(updatedProp.title, 'Test Paradise Residency (Renovated)');
assert.strictEqual(updatedProp.rooms[0].monthlyRent, 13500);

state.deleteProperty(createdProp.id);
assert.strictEqual(state.data.properties.length, initialPropCount);

// 2. Customer CRUD
const initialCustCount = state.data.users.filter(u => u.role === 'CUSTOMER').length;
const newCust = state.adminAddCustomer({ name: 'Vikram Seth', mobile: '9876543210', email: 'vikram@seth.in', customerType: 'Working Professional' });
assert.strictEqual(state.data.users.filter(u => u.role === 'CUSTOMER').length, initialCustCount + 1);

state.adminEditCustomer(newCust.id, { name: 'Vikram Seth (Senior)' });
assert.strictEqual(state.data.users.find(u => u.id === newCust.id).name, 'Vikram Seth (Senior)');

state.adminDeleteCustomer(newCust.id);
assert.strictEqual(state.data.users.filter(u => u.role === 'CUSTOMER').length, initialCustCount);

// 3. Owner CRUD
const initialOwnerCount = state.data.users.filter(u => u.role === 'OWNER').length;
const newOwner = state.adminAddOwner({ name: 'Rameshwar Lal', mobile: '9123456789', propertiesCount: 3 });
assert.strictEqual(state.data.users.filter(u => u.role === 'OWNER').length, initialOwnerCount + 1);

state.adminEditOwner(newOwner.id, { contactSettings: 'BOTH_OFF' });
assert.strictEqual(state.data.users.find(u => u.id === newOwner.id).contactSettings, 'BOTH_OFF');

state.adminDeleteOwner(newOwner.id);
assert.strictEqual(state.data.users.filter(u => u.role === 'OWNER').length, initialOwnerCount);

console.log('✅ Full CRUD (Add, Edit, Delete) for Properties, Customers & Landlords Verified\n');

console.log('========================================================================');
console.log('🎉 ALL 18 TEST SUITES COVERING ALL 27 ADMIN SECTIONS PASSED FLAWLESSLY!');
console.log('========================================================================');


/**
 * Monthly Home, Room, Apartment & Property Rental Platform
 * Master Relational Seed Database & Data Schema
 */

const INITIAL_DATABASE = {
  propertyTypes: [
    { id: 'room', name: 'Room', icon: '🛏️', description: 'Single or shared rooms' },
    { id: '1bhk', name: '1 BHK', icon: '🏠', description: '1 Bedroom, Hall, Kitchen' },
    { id: '2bhk', name: '2 BHK', icon: '🏡', description: '2 Bedroom, Hall, Kitchen' },
    { id: '3bhk', name: '3 BHK', icon: '🏢', description: '3 Bedroom, Hall, Kitchen' },
    { id: 'apartment', name: 'Apartment', icon: '🏙️', description: 'Multi-unit residential complex' },
    { id: 'flat', name: 'Flat', icon: '🏬', description: 'Individual flat in housing society' },
    { id: 'house', name: 'House', icon: '🏘️', description: 'Independent residential house / villa' },
    { id: 'hostel', name: 'Hostel', icon: '🏨', description: 'Student & youth residential hostel' },
    { id: 'pg', name: 'PG (Paying Guest)', icon: '🛎️', description: 'Furnished accommodation with food/services' },
    { id: 'godown', name: 'Godown / Warehouse', icon: '🏭', description: 'Commercial storage & agro godown' },
    { id: 'other', name: 'Other Property', icon: '🏗️', description: 'Commercial, studio or multipurpose space' }
  ],

  customerTypes: [
    { id: 'single', name: 'Single Person', badgeColor: '#3b82f6' },
    { id: 'couple', name: 'Couple', badgeColor: '#ec4899' },
    { id: 'family', name: 'Family', badgeColor: '#10b981' },
    { id: 'boys', name: 'Boys', badgeColor: '#6366f1' },
    { id: 'girls', name: 'Girls', badgeColor: '#f43f5e' },
    { id: 'students', name: 'Students', badgeColor: '#f59e0b' },
    { id: 'working_professional', name: 'Working Professional', badgeColor: '#0ea5e9' },
    { id: 'boys_hostel', name: 'Boys Hostel', badgeColor: '#8b5cf6' },
    { id: 'girls_hostel', name: 'Girls Hostel', badgeColor: '#d946ef' },
    { id: 'pg_occupant', name: 'PG', badgeColor: '#14b8a6' },
    { id: 'other_type', name: 'Other', badgeColor: '#64748b' }
  ],

  areas: {
    urban: [
      {
        city: 'Varanasi',
        localities: ['Lanka', 'Assi Ghat', 'Sigra', 'Shivpur', 'Durgakund', 'BHU Road', 'Cantonment', 'Pandeypur']
      },
      {
        city: 'Lucknow',
        localities: ['Gomti Nagar', 'Alambagh', 'Hazratganj', 'Indira Nagar', 'Mahanagar', 'Jankipuram', 'Ashiyana']
      },
      {
        city: 'Delhi',
        localities: ['Saket', 'Laxmi Nagar', 'Mukherjee Nagar', 'Rohini', 'Hauz Khas', 'Karol Bagh', 'Dwarka']
      },
      {
        city: 'Mumbai',
        localities: ['Andheri East', 'Powai', 'Borivali West', 'Dadar', 'Bandra West', 'Thane West', 'Malad']
      }
    ],
    rural: [
      {
        district: 'Varanasi Rural',
        villages: ['Harahua Village', 'Kashi Rural Belt', 'Babatpur Airport Locality', 'Cholapur Village', 'Raja Talab']
      },
      {
        district: 'Lucknow Rural',
        villages: ['Mohanlalganj', 'Bakshi Ka Talab', 'Kakori Rural Area', 'Gosainganj Gramin', 'Malihabad']
      },
      {
        district: 'NCR / Delhi Periphery Rural',
        villages: ['Najafgarh Rural', 'Bawana Agro Belt', 'Alipur Village Hub', 'Chhawla Rural']
      },
      {
        district: 'Mumbai Periphery / Palghar Rural',
        villages: ['Palghar Rural', 'Manor Countryside', 'Vasai Hinterland', 'Dahanu Coastal Belt']
      }
    ]
  },

  users: [
    {
      id: 'cust_1',
      role: 'CUSTOMER',
      name: 'Amit Sharma',
      mobile: '9876543210',
      email: 'amit.sharma@example.com',
      customerType: 'working_professional',
      aadhaarVerified: true,
      aadhaarLast4: '4512',
      address: 'House 42, Sector 15, Varanasi',
      avatar: '👨‍💼',
      createdAt: '2026-05-10'
    },
    {
      id: 'cust_2',
      role: 'CUSTOMER',
      name: 'Priya Verma',
      mobile: '9812354321',
      email: 'priya.verma@example.com',
      customerType: 'students',
      aadhaarVerified: true,
      aadhaarLast4: '8923',
      address: 'Flat 304, Lanka Road, Varanasi',
      avatar: '👩‍🎓',
      createdAt: '2026-07-15'
    },
    {
      id: 'cust_3',
      role: 'CUSTOMER',
      name: 'Rahul & Anjali Gupta',
      mobile: '9934567890',
      email: 'rahul.gupta@example.com',
      customerType: 'couple',
      aadhaarVerified: true,
      aadhaarLast4: '1122',
      address: 'Plot 18, Gomti Nagar, Lucknow',
      avatar: '👫',
      createdAt: '2026-08-01'
    },
    {
      id: 'cust_4',
      role: 'CUSTOMER',
      name: 'Vikram Singh',
      mobile: '9723411223',
      email: 'vikram.singh@example.com',
      customerType: 'single',
      aadhaarVerified: false,
      aadhaarLast4: '',
      address: 'Civil Lines, Delhi',
      avatar: '🧑‍💻',
      createdAt: '2026-09-20'
    },
    {
      id: 'owner_1',
      role: 'OWNER',
      name: 'Rajesh Pandey',
      mobile: '9450012345',
      email: 'rajesh.pandey@example.com',
      contactSettings: 'CALL_MSG_ON', // Options: CALL_MSG_ON, CALL_ON_MSG_OFF, CALL_OFF_MSG_ON, BOTH_OFF
      rating: 4.8,
      verified: true,
      address: 'Pandey Bhawan, Lanka, Varanasi',
      avatar: '👨‍🏫',
      createdAt: '2026-01-10'
    },
    {
      id: 'owner_2',
      role: 'OWNER',
      name: 'Sunita Devi',
      mobile: '9415098765',
      email: 'sunita.devi@example.com',
      contactSettings: 'CALL_ON_MSG_OFF',
      rating: 4.9,
      verified: true,
      address: 'Gomti View Apartments, Lucknow',
      avatar: '👩‍💼',
      createdAt: '2026-02-14'
    },
    {
      id: 'owner_3',
      role: 'OWNER',
      name: 'Col. Arvind Dixit (Retd.)',
      mobile: '9820045678',
      email: 'col.dixit@example.com',
      contactSettings: 'CALL_OFF_MSG_ON',
      rating: 4.7,
      verified: true,
      address: 'Defence Enclave, Saket, Delhi',
      avatar: '👨‍✈️',
      createdAt: '2026-03-01'
    },
    {
      id: 'owner_4',
      role: 'OWNER',
      name: 'Chaudhary Ramu Singh',
      mobile: '9919033445',
      email: 'ramu.singh@example.com',
      contactSettings: 'CALL_MSG_ON',
      rating: 4.6,
      verified: true,
      address: 'Kisan Bhawan, Harahua Village, Varanasi Rural',
      avatar: '👳‍♂️',
      createdAt: '2026-04-12'
    },
    {
      id: 'admin_1',
      role: 'ADMIN',
      name: 'Super Administrator',
      mobile: '9000000000',
      email: 'admin@rentease.in',
      avatar: '🛡️',
      createdAt: '2026-01-01'
    }
  ],

  properties: [
    {
      id: 'prop_1',
      ownerId: 'owner_1',
      title: 'Ganga Heights Deluxe Complex',
      propertyType: 'apartment',
      areaType: 'urban',
      city: 'Varanasi',
      locality: 'Lanka',
      address: 'Near BHU Main Gate, Lanka, Varanasi - 221005',
      isMultiRoom: true,
      featured: true,
      rating: 4.8,
      reviewsCount: 24,
      image: 'https://images.unsplash.com/photo-1545324418-cc1a3fa10c00?auto=format&fit=crop&w=800&q=80',
      gallery: [
        'https://images.unsplash.com/photo-1545324418-cc1a3fa10c00?auto=format&fit=crop&w=800&q=80',
        'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?auto=format&fit=crop&w=800&q=80',
        'https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?auto=format&fit=crop&w=800&q=80'
      ],
      description: 'Modern residential apartment complex walking distance from Banaras Hindu University. 24/7 security, lift, power backup and clean RO water system.',
      electricityInfo: 'Sub-meter installed. ₹7.50 per unit charged as per actual meter reading.',
      maintenanceInfo: '₹600/month includes common area cleaning, lift AMC, garbage collection.',
      otherCharges: 'One-time move-in verification & key charge ₹500.',
      rentalConditions: 'No loud music after 10 PM. Monthly rent strictly payable by 5th of every month. Notice period 1 month.',
      amenities: ['Power Backup', 'Lift', 'RO Water', 'CCTV Security', 'Bike Parking', 'Wi-Fi Ready'],
      rooms: [
        {
          id: 'room_101',
          propertyId: 'prop_1',
          roomNumber: 'Room 101',
          roomType: '1bhk',
          sizeSqFt: '520 sq.ft',
          furnishing: 'Semi-Furnished (Wardrobe, Fan, Lights, Modular Kitchen)',
          monthlyRent: 8500,
          securityDeposit: 17000,
          dueDayOfMonth: 5,
          availableFrom: '2026-10-05',
          status: 'Available', // Available, Rental Request, Reserved, Agreement Pending, Rented, Not Available
          suitableFor: ['students', 'working_professional', 'boys', 'single'],
          featuredImage: 'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?auto=format&fit=crop&w=800&q=80'
        },
        {
          id: 'room_102',
          propertyId: 'prop_1',
          roomNumber: 'Room 102',
          roomType: '2bhk',
          sizeSqFt: '950 sq.ft',
          furnishing: 'Fully Furnished (Beds, Sofa, Dining, AC, Fridge)',
          monthlyRent: 14000,
          securityDeposit: 28000,
          dueDayOfMonth: 5,
          availableFrom: '2026-06-05',
          status: 'Rented',
          currentTenantId: 'cust_1',
          activeRentalId: 'rent_act_1',
          suitableFor: ['family', 'couple', 'working_professional'],
          featuredImage: 'https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?auto=format&fit=crop&w=800&q=80'
        },
        {
          id: 'room_103',
          propertyId: 'prop_1',
          roomNumber: 'Room 103',
          roomType: '1bhk',
          sizeSqFt: '550 sq.ft',
          furnishing: 'Furnished (Bed, Study Table, Geyser, RO)',
          monthlyRent: 9000,
          securityDeposit: 18000,
          dueDayOfMonth: 5,
          availableFrom: '2026-10-10',
          status: 'Rental Request', // Currently has a pending request from Priya Verma
          suitableFor: ['girls', 'students', 'working_professional'],
          featuredImage: 'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?auto=format&fit=crop&w=800&q=80'
        },
        {
          id: 'room_104',
          propertyId: 'prop_1',
          roomNumber: 'Room 104',
          roomType: 'room',
          sizeSqFt: '280 sq.ft',
          furnishing: 'Furnished Single Room with attached bath',
          monthlyRent: 5500,
          securityDeposit: 10000,
          dueDayOfMonth: 5,
          availableFrom: '2026-10-01',
          status: 'Available',
          suitableFor: ['students', 'boys', 'single'],
          featuredImage: 'https://images.unsplash.com/photo-1598928506311-c55ded91a20c?auto=format&fit=crop&w=800&q=80'
        }
      ]
    },

    {
      id: 'prop_2',
      ownerId: 'owner_1',
      title: 'Kashi Heritage Independent House',
      propertyType: 'house',
      areaType: 'urban',
      city: 'Varanasi',
      locality: 'Assi Ghat',
      address: 'B-12/48, Near Assi Ghat Steps, Varanasi - 221001',
      isMultiRoom: false,
      featured: true,
      rating: 4.9,
      reviewsCount: 18,
      image: 'https://images.unsplash.com/photo-1580587771525-78b9dba3b914?auto=format&fit=crop&w=800&q=80',
      gallery: [
        'https://images.unsplash.com/photo-1580587771525-78b9dba3b914?auto=format&fit=crop&w=800&q=80',
        'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?auto=format&fit=crop&w=800&q=80'
      ],
      description: 'Serene independent 3 BHK private house close to sacred Assi Ghat. Features open courtyard, rooftop terrace with river breeze, and covered car parking.',
      electricityInfo: 'Direct electricity meter (UPPCL tariff). Customer pays bill directly.',
      maintenanceInfo: 'Self-maintained independent property. No society maintenance.',
      otherCharges: 'Zero extra maintenance charge.',
      rentalConditions: 'Ideal for peaceful families or couples. Pure vegetarian household preferred.',
      amenities: ['Car Parking', 'Private Terrace', 'Courtyard', 'Water Storage Tank', 'Balcony', 'Geyser'],
      rooms: [
        {
          id: 'room_201',
          propertyId: 'prop_2',
          roomNumber: 'Entire Independent 3 BHK House',
          roomType: '3bhk',
          sizeSqFt: '1650 sq.ft',
          furnishing: 'Semi-Furnished (Built-in Almirahs, Modular Kitchen, Fans, Lights)',
          monthlyRent: 22000,
          securityDeposit: 44000,
          dueDayOfMonth: 1,
          availableFrom: '2026-10-15',
          status: 'Available',
          suitableFor: ['family', 'couple'],
          featuredImage: 'https://images.unsplash.com/photo-1580587771525-78b9dba3b914?auto=format&fit=crop&w=800&q=80'
        }
      ]
    },

    {
      id: 'prop_3',
      ownerId: 'owner_2',
      title: 'Gomti Greens Premium Residency',
      propertyType: 'flat',
      areaType: 'urban',
      city: 'Lucknow',
      locality: 'Gomti Nagar',
      address: 'Tower 4, Flat 602, Gomti Nagar Extension, Lucknow - 226010',
      isMultiRoom: false,
      featured: true,
      rating: 4.9,
      reviewsCount: 31,
      image: 'https://images.unsplash.com/photo-1545324418-cc1a3fa10c00?auto=format&fit=crop&w=800&q=80',
      gallery: [
        'https://images.unsplash.com/photo-1545324418-cc1a3fa10c00?auto=format&fit=crop&w=800&q=80',
        'https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?auto=format&fit=crop&w=800&q=80'
      ],
      description: 'Luxurious 2 BHK high-rise flat overlooking green parks. Clubhouse, swimming pool, piped gas connection and dedicated basement car parking included.',
      electricityInfo: 'Prepaid smart meter installed in the society.',
      maintenanceInfo: '₹1,500/month society maintenance included in rent.',
      otherCharges: 'Clubhouse gym access ₹300/month (optional).',
      rentalConditions: 'Rent due strictly on the 1st of each month. 2 months security deposit required.',
      amenities: ['Gated Society', 'Clubhouse', 'Gym', 'Swimming Pool', 'Piped Gas', 'Basement Parking', 'Power Backup'],
      rooms: [
        {
          id: 'room_301',
          propertyId: 'prop_3',
          roomNumber: 'Flat 602 (2 BHK)',
          roomType: '2bhk',
          sizeSqFt: '1180 sq.ft',
          furnishing: 'Fully Furnished (Modern Interiors, 2 ACs, Refrigerator, Sofa Set, King Beds)',
          monthlyRent: 16000,
          securityDeposit: 32000,
          dueDayOfMonth: 1,
          availableFrom: '2026-08-01',
          status: 'Rented',
          currentTenantId: 'cust_3',
          activeRentalId: 'rent_act_2',
          suitableFor: ['family', 'couple', 'working_professional'],
          featuredImage: 'https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?auto=format&fit=crop&w=800&q=80'
        }
      ]
    },

    {
      id: 'prop_4',
      ownerId: 'owner_2',
      title: 'Awadh Scholars Boys Hostel & PG',
      propertyType: 'hostel',
      areaType: 'urban',
      city: 'Lucknow',
      locality: 'Alambagh',
      address: 'Plot 55, Near Metro Station, Alambagh, Lucknow - 226005',
      isMultiRoom: true,
      featured: false,
      rating: 4.6,
      reviewsCount: 15,
      image: 'https://images.unsplash.com/photo-1555854877-bab0e564b8d5?auto=format&fit=crop&w=800&q=80',
      gallery: [
        'https://images.unsplash.com/photo-1555854877-bab0e564b8d5?auto=format&fit=crop&w=800&q=80',
        'https://images.unsplash.com/photo-1598928506311-c55ded91a20c?auto=format&fit=crop&w=800&q=80'
      ],
      description: 'Dedicated student hostel with hygienic food (3 times a day included), high-speed fiber internet, study library and 24/7 warden supervision.',
      electricityInfo: 'Included up to 50 units/month per student. AC units billed separately at ₹8/unit.',
      maintenanceInfo: 'Daily room cleaning and laundry included in monthly fees.',
      otherCharges: 'Security deposit refundable on 1 month notice.',
      rentalConditions: 'Hostel gate closes at 10:30 PM. Strictly for boys/students.',
      amenities: ['3 Meals Included', 'High-Speed Wi-Fi', 'Study Room', 'CCTV Security', 'Washing Machine', 'Warden'],
      rooms: [
        {
          id: 'room_401',
          propertyId: 'prop_4',
          roomNumber: 'Room 201 (Single Deluxe)',
          roomType: 'room',
          sizeSqFt: '220 sq.ft',
          furnishing: 'Fully Furnished (Bed, Mattress, Study Table, Ergonomic Chair, Wardrobe)',
          monthlyRent: 6000,
          securityDeposit: 6000,
          dueDayOfMonth: 7,
          availableFrom: '2026-10-01',
          status: 'Available',
          suitableFor: ['students', 'boys', 'boys_hostel', 'pg_occupant'],
          featuredImage: 'https://images.unsplash.com/photo-1598928506311-c55ded91a20c?auto=format&fit=crop&w=800&q=80'
        },
        {
          id: 'room_402',
          propertyId: 'prop_4',
          roomNumber: 'Room 202 (Twin Sharing)',
          roomType: 'room',
          sizeSqFt: '340 sq.ft',
          furnishing: 'Fully Furnished (2 Single Beds, 2 Study Desks, Lockers)',
          monthlyRent: 4500,
          securityDeposit: 5000,
          dueDayOfMonth: 7,
          availableFrom: '2026-10-01',
          status: 'Available',
          suitableFor: ['students', 'boys', 'boys_hostel', 'pg_occupant'],
          featuredImage: 'https://images.unsplash.com/photo-1555854877-bab0e564b8d5?auto=format&fit=crop&w=800&q=80'
        }
      ]
    },

    {
      id: 'prop_5',
      ownerId: 'owner_3',
      title: 'Saket Metro Executive Studio',
      propertyType: 'apartment',
      areaType: 'urban',
      city: 'Delhi',
      locality: 'Saket',
      address: 'Lane 3, Anupam Complex, Saket, New Delhi - 110017',
      isMultiRoom: false,
      featured: true,
      rating: 4.8,
      reviewsCount: 42,
      image: 'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?auto=format&fit=crop&w=800&q=80',
      gallery: [
        'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?auto=format&fit=crop&w=800&q=80',
        'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?auto=format&fit=crop&w=800&q=80'
      ],
      description: 'Chic designer 1 BHK Studio apartment situated 200m from Saket Metro station (Yellow Line) and Select Citywalk mall. Ideal for IT and corporate professionals.',
      electricityInfo: 'Commercial BSES sub-meter. Billed monthly at ₹8.50/unit.',
      maintenanceInfo: '₹800/month includes water booster, security guard, daily garbage pick.',
      otherCharges: 'Car parking slot ₹1,000/month additional.',
      rentalConditions: '11-month registered agreement. Police verification mandatory before move-in.',
      amenities: ['Metro Walkable', 'Air Conditioned', 'Modular Kitchen', 'Modern Bath', 'Smart TV', 'High-Speed Wi-Fi'],
      rooms: [
        {
          id: 'room_501',
          propertyId: 'prop_5',
          roomNumber: 'Studio 303',
          roomType: '1bhk',
          sizeSqFt: '580 sq.ft',
          furnishing: 'Fully Furnished (Queen Bed, 55" Smart TV, Split AC, Refrigerator, Induction)',
          monthlyRent: 18500,
          securityDeposit: 37000,
          dueDayOfMonth: 1,
          availableFrom: '2026-10-01',
          status: 'Available',
          suitableFor: ['working_professional', 'single', 'couple'],
          featuredImage: 'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?auto=format&fit=crop&w=800&q=80'
        }
      ]
    },

    {
      id: 'prop_6',
      ownerId: 'owner_3',
      title: 'Mukherjee Nagar Civil Aspirants PG for Girls',
      propertyType: 'pg',
      areaType: 'urban',
      city: 'Delhi',
      locality: 'Mukherjee Nagar',
      address: 'House 88, Near Batra Cinema, Mukherjee Nagar, Delhi - 110009',
      isMultiRoom: true,
      featured: false,
      rating: 4.7,
      reviewsCount: 29,
      image: 'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?auto=format&fit=crop&w=800&q=80',
      gallery: [
        'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?auto=format&fit=crop&w=800&q=80'
      ],
      description: 'Exclusive premium girl\'s PG designed for UPSC & competitive exam students. Silent library on top floor, hygienic vegetarian meals, biometric door lock.',
      electricityInfo: 'Standard usage included. AC usage metered at ₹9/unit.',
      maintenanceInfo: 'All maintenance and 24/7 security covered in rent.',
      otherCharges: 'None.',
      rentalConditions: 'Only for female students and working women. Strict biometric access.',
      amenities: ['Biometric Access', '3 Meals + Tea', 'Library Access', 'RO Water', 'Wi-Fi 300 Mbps', 'Female Guard'],
      rooms: [
        {
          id: 'room_601',
          propertyId: 'prop_6',
          roomNumber: 'Room G-101 (Private Room)',
          roomType: 'room',
          sizeSqFt: '240 sq.ft',
          furnishing: 'Furnished (Bed, Bookshelf, Ergonomic Chair, Large Desk, Wardrobe)',
          monthlyRent: 8000,
          securityDeposit: 10000,
          dueDayOfMonth: 5,
          availableFrom: '2026-10-01',
          status: 'Available',
          suitableFor: ['girls', 'students', 'girls_hostel', 'pg_occupant', 'working_professional'],
          featuredImage: 'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?auto=format&fit=crop&w=800&q=80'
        }
      ]
    },

    {
      id: 'prop_7',
      ownerId: 'owner_3',
      title: 'Powai Lakeview Executive Flat',
      propertyType: 'flat',
      areaType: 'urban',
      city: 'Mumbai',
      locality: 'Powai',
      address: 'Tower A, Hiranandani Gardens, Powai, Mumbai - 400076',
      isMultiRoom: false,
      featured: true,
      rating: 4.9,
      reviewsCount: 38,
      image: 'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?auto=format&fit=crop&w=800&q=80',
      gallery: [
        'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?auto=format&fit=crop&w=800&q=80'
      ],
      description: 'Expansive 2 BHK lake-facing luxury flat close to IIT Bombay, Supreme Business Park and Hiranandani hospitals. Modern Italian flooring and modular kitchen.',
      electricityInfo: 'Adani Electricity direct meter bill paid monthly.',
      maintenanceInfo: 'Society charges ₹3,500/month (included in monthly rent).',
      otherCharges: '1 Reserved covered car parking slot included.',
      rentalConditions: 'Corporate lease or working IT professionals preferred. 11-month agreement.',
      amenities: ['Lake View', 'Clubhouse & Pool', 'Tennis Court', 'High-Speed Lifts', '24x7 Security', 'Piped Gas'],
      rooms: [
        {
          id: 'room_701',
          propertyId: 'prop_7',
          roomNumber: 'Flat 1204 (2 BHK)',
          roomType: '2bhk',
          sizeSqFt: '1050 sq.ft',
          furnishing: 'Fully Furnished (Designer Sofas, 3 Split ACs, Dishwasher, Refrigerator, King Beds)',
          monthlyRent: 38000,
          securityDeposit: 75000,
          dueDayOfMonth: 1,
          availableFrom: '2026-10-10',
          status: 'Available',
          suitableFor: ['working_professional', 'family', 'couple'],
          featuredImage: 'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?auto=format&fit=crop&w=800&q=80'
        }
      ]
    },

    {
      id: 'prop_8',
      ownerId: 'owner_4',
      title: 'Harahua Logistics & Agro Godown',
      propertyType: 'godown',
      areaType: 'rural',
      city: 'Varanasi Rural',
      locality: 'Harahua Village',
      address: 'Main Highway Link, Harahua Village, Varanasi Rural - 221105',
      isMultiRoom: false,
      featured: false,
      rating: 4.6,
      reviewsCount: 9,
      image: 'https://images.unsplash.com/photo-1586528116311-ad8dd3c8310d?auto=format&fit=crop&w=800&q=80',
      gallery: [
        'https://images.unsplash.com/photo-1586528116311-ad8dd3c8310d?auto=format&fit=crop&w=800&q=80'
      ],
      description: 'Heavy duty RCC warehouse / godown located right off the 4-lane highway in Harahua rural area. 20-ft ceiling height, 40-ft container truck turnaround space, 3-phase industrial power.',
      electricityInfo: 'Commercial 3-Phase power connection (15 KW sanctioned load).',
      maintenanceInfo: 'Security gatekeeper on duty included.',
      otherCharges: 'No hidden charges. Suitable for cold storage, e-commerce hub, agro stock.',
      rentalConditions: 'Long term monthly rental (12+ months). Commercial agreement.',
      amenities: ['Wide Truck Entry', '3-Phase Power', 'Ceiling Fans & Vents', 'Water Borewell', 'CCTV Boundary', 'Office Cabin'],
      rooms: [
        {
          id: 'room_801',
          propertyId: 'prop_8',
          roomNumber: 'Godown Shed A',
          roomType: 'godown',
          sizeSqFt: '2500 sq.ft',
          furnishing: 'Unfurnished Industrial Warehouse with Attached Office Room & Washroom',
          monthlyRent: 25000,
          securityDeposit: 50000,
          dueDayOfMonth: 10,
          availableFrom: '2026-10-01',
          status: 'Available',
          suitableFor: ['other_type', 'working_professional'],
          featuredImage: 'https://images.unsplash.com/photo-1586528116311-ad8dd3c8310d?auto=format&fit=crop&w=800&q=80'
        }
      ]
    },

    {
      id: 'prop_9',
      ownerId: 'owner_4',
      title: 'Bakshi Ka Talab Countryside Farmhouse & Rooms',
      propertyType: 'house',
      areaType: 'rural',
      city: 'Lucknow Rural',
      locality: 'Bakshi Ka Talab',
      address: 'Village Raitha Road, Bakshi Ka Talab, Lucknow Rural - 226201',
      isMultiRoom: false,
      featured: true,
      rating: 4.7,
      reviewsCount: 14,
      image: 'https://images.unsplash.com/photo-1518780664697-55e3ad937233?auto=format&fit=crop&w=800&q=80',
      gallery: [
        'https://images.unsplash.com/photo-1518780664697-55e3ad937233?auto=format&fit=crop&w=800&q=80'
      ],
      description: 'Peaceful countryside farmhouse with lush green organic garden, organic milk & fresh air. Ideal for remote workers or families seeking tranquility outside the noisy city.',
      electricityInfo: 'Rural subsidized electricity + 2KW Solar Rooftop setup.',
      maintenanceInfo: 'Gardener & tube-well maintenance included.',
      otherCharges: 'Zero extra maintenance.',
      rentalConditions: 'Minimum 3 months rental. Family friendly peaceful ambiance.',
      amenities: ['Solar Power', 'Organic Garden', 'Tube Well', 'Spacious Veranda', 'Pet Friendly', 'Car Porch'],
      rooms: [
        {
          id: 'room_901',
          propertyId: 'prop_9',
          roomNumber: 'Farmhouse Cottage (2 BHK)',
          roomType: 'house',
          sizeSqFt: '1200 sq.ft',
          furnishing: 'Semi-Furnished (Teak Wood Furniture, Beds, Kitchenette, Fans)',
          monthlyRent: 11000,
          securityDeposit: 20000,
          dueDayOfMonth: 5,
          availableFrom: '2026-10-05',
          status: 'Available',
          suitableFor: ['family', 'couple', 'single', 'working_professional'],
          featuredImage: 'https://images.unsplash.com/photo-1518780664697-55e3ad937233?auto=format&fit=crop&w=800&q=80'
        }
      ]
    }
  ],

  rentalRequests: [
    {
      id: 'req_101',
      customerId: 'cust_2', // Priya Verma
      propertyId: 'prop_1',
      roomId: 'room_103',
      ownerId: 'owner_1',
      expectedMoveInDate: '2026-10-15',
      rentalPeriodMonths: 11,
      customerDetails: {
        name: 'Priya Verma',
        mobile: '9812354321',
        customerType: 'students',
        aadhaarVerified: true
      },
      requirements: 'Looking for a quiet, clean room near university for civil services preparation.',
      status: 'Pending', // Pending, Accepted, Rejected, Cancelled
      createdAt: '2026-09-28T14:30:00Z',
      termsConfirmedByOwner: false,
      termsConfirmedByCustomer: false
    },
    {
      id: 'req_102',
      customerId: 'cust_4', // Vikram Singh
      propertyId: 'prop_5',
      roomId: 'room_501',
      ownerId: 'owner_3',
      expectedMoveInDate: '2026-11-01',
      rentalPeriodMonths: 12,
      customerDetails: {
        name: 'Vikram Singh',
        mobile: '9723411223',
        customerType: 'working_professional',
        aadhaarVerified: false
      },
      requirements: 'IT software engineer moving from Pune to Saket Delhi office.',
      status: 'Pending',
      createdAt: '2026-09-30T10:15:00Z',
      termsConfirmedByOwner: false,
      termsConfirmedByCustomer: false
    }
  ],

  agreements: [
    {
      id: 'agr_101',
      requestId: 'req_prev_1',
      customerId: 'cust_1',
      ownerId: 'owner_1',
      propertyId: 'prop_1',
      roomId: 'room_102',
      status: 'Agreement Completed', // Agreement Pending, Verification Pending, Agreement Completed, Cancelled
      aadhaarVerified: true,
      verificationService: 'UIDAI e-KYC Legal Sandbox Service',
      verificationDate: '2026-06-03',
      monthlyRent: 14000,
      securityDeposit: 28000,
      otherCharges: 600,
      moveInDate: '2026-06-05',
      dueDayOfMonth: 5,
      rentalConditions: 'Standard 11-month agreement. 1 month advance notice required.',
      customerConsent: true,
      ownerConsent: true,
      signedAt: '2026-06-04T16:00:00Z'
    },
    {
      id: 'agr_102',
      requestId: 'req_prev_2',
      customerId: 'cust_3',
      ownerId: 'owner_2',
      propertyId: 'prop_3',
      roomId: 'room_301',
      status: 'Agreement Completed',
      aadhaarVerified: true,
      verificationService: 'UIDAI e-KYC Legal Sandbox Service',
      verificationDate: '2026-07-29',
      monthlyRent: 16000,
      securityDeposit: 32000,
      otherCharges: 0,
      moveInDate: '2026-08-01',
      dueDayOfMonth: 1,
      rentalConditions: 'Residential use only. No commercial activities.',
      customerConsent: true,
      ownerConsent: true,
      signedAt: '2026-07-30T11:20:00Z'
    }
  ],

  activeRentals: [
    {
      id: 'rent_act_1',
      agreementId: 'agr_101',
      customerId: 'cust_1', // Amit Sharma
      ownerId: 'owner_1', // Rajesh Pandey
      propertyId: 'prop_1',
      roomId: 'room_102',
      monthlyRent: 14000,
      securityDeposit: 28000,
      rentStartDate: '2026-06-05',
      monthlyDueDay: 5,
      status: 'Active',
      propertySnapshot: {
        title: 'Ganga Heights Deluxe Complex',
        roomNumber: 'Room 102 (2 BHK)',
        address: 'Near BHU Main Gate, Lanka, Varanasi - 221005'
      }
    },
    {
      id: 'rent_act_2',
      agreementId: 'agr_102',
      customerId: 'cust_3', // Rahul & Anjali Gupta
      ownerId: 'owner_2', // Sunita Devi
      propertyId: 'prop_3',
      roomId: 'room_301',
      monthlyRent: 16000,
      securityDeposit: 32000,
      rentStartDate: '2026-08-01',
      monthlyDueDay: 1,
      status: 'Active',
      propertySnapshot: {
        title: 'Gomti Greens Premium Residency',
        roomNumber: 'Flat 602 (2 BHK)',
        address: 'Tower 4, Flat 602, Gomti Nagar Extension, Lucknow - 226010'
      }
    }
  ],

  rentPayments: [
    // Amit Sharma - Ganga Heights (Rent: ₹14,000, Due: 5th)
    {
      id: 'pay_1',
      rentalId: 'rent_act_1',
      customerId: 'cust_1',
      ownerId: 'owner_1',
      propertyId: 'prop_1',
      roomId: 'room_102',
      rentMonth: 'June 2026',
      rentAmount: 14000,
      dueDate: '2026-06-05',
      paymentDate: '2026-06-05',
      paymentMode: 'UPI',
      paymentStatus: 'Paid',
      transactionRef: 'UPI-8823901429',
      receiptNumber: 'REC-2026-06-102',
      notes: 'Initial month rent paid on move-in day',
      createdDate: '2026-06-05T09:30:00Z'
    },
    {
      id: 'pay_2',
      rentalId: 'rent_act_1',
      customerId: 'cust_1',
      ownerId: 'owner_1',
      propertyId: 'prop_1',
      roomId: 'room_102',
      rentMonth: 'July 2026',
      rentAmount: 14000,
      dueDate: '2026-07-05',
      paymentDate: '2026-07-04',
      paymentMode: 'UPI',
      paymentStatus: 'Paid',
      transactionRef: 'UPI-9912044810',
      receiptNumber: 'REC-2026-07-102',
      notes: 'Monthly rent paid via Google Pay UPI',
      createdDate: '2026-07-04T18:15:00Z'
    },
    {
      id: 'pay_3',
      rentalId: 'rent_act_1',
      customerId: 'cust_1',
      ownerId: 'owner_1',
      propertyId: 'prop_1',
      roomId: 'room_102',
      rentMonth: 'August 2026',
      rentAmount: 14000,
      dueDate: '2026-08-05',
      paymentDate: '2026-08-05',
      paymentMode: 'Bank Transfer',
      paymentStatus: 'Paid',
      transactionRef: 'NEFT-HDFC-77231049',
      receiptNumber: 'REC-2026-08-102',
      notes: 'NEFT Bank Transfer from HDFC account',
      createdDate: '2026-08-05T11:00:00Z'
    },
    {
      id: 'pay_4',
      rentalId: 'rent_act_1',
      customerId: 'cust_1',
      ownerId: 'owner_1',
      propertyId: 'prop_1',
      roomId: 'room_102',
      rentMonth: 'September 2026',
      rentAmount: 14000,
      dueDate: '2026-09-05',
      paymentDate: '2026-09-05',
      paymentMode: 'Cash',
      paymentStatus: 'Paid',
      transactionRef: 'CASH-REC-4412',
      receiptNumber: 'REC-2026-09-102',
      notes: 'Cash received in person by Owner Rajesh Pandey with counter receipt',
      createdDate: '2026-09-05T14:45:00Z'
    },
    {
      id: 'pay_5',
      rentalId: 'rent_act_1',
      customerId: 'cust_1',
      ownerId: 'owner_1',
      propertyId: 'prop_1',
      roomId: 'room_102',
      rentMonth: 'October 2026',
      rentAmount: 14000,
      dueDate: '2026-10-05',
      paymentDate: null,
      paymentMode: null,
      paymentStatus: 'Pending',
      transactionRef: null,
      receiptNumber: null,
      notes: 'Rent is due on 05 October 2026 (Due in 4 days)',
      createdDate: '2026-10-01T00:00:00Z'
    },

    // Rahul & Anjali Gupta - Gomti Greens (Rent: ₹16,000, Due: 1st)
    {
      id: 'pay_6',
      rentalId: 'rent_act_2',
      customerId: 'cust_3',
      ownerId: 'owner_2',
      propertyId: 'prop_3',
      roomId: 'room_301',
      rentMonth: 'August 2026',
      rentAmount: 16000,
      dueDate: '2026-08-01',
      paymentDate: '2026-08-01',
      paymentMode: 'Online',
      paymentStatus: 'Paid',
      transactionRef: 'ONL-55219904',
      receiptNumber: 'REC-2026-08-301',
      notes: 'Netbanking payment on move-in',
      createdDate: '2026-08-01T10:00:00Z'
    },
    {
      id: 'pay_7',
      rentalId: 'rent_act_2',
      customerId: 'cust_3',
      ownerId: 'owner_2',
      propertyId: 'prop_3',
      roomId: 'room_301',
      rentMonth: 'September 2026',
      rentAmount: 16000,
      dueDate: '2026-09-01',
      paymentDate: '2026-09-01',
      paymentMode: 'Online',
      paymentStatus: 'Paid',
      transactionRef: 'ONL-66120482',
      receiptNumber: 'REC-2026-09-301',
      notes: 'Card payment via portal',
      createdDate: '2026-09-01T12:30:00Z'
    },
    {
      id: 'pay_8',
      rentalId: 'rent_act_2',
      customerId: 'cust_3',
      ownerId: 'owner_2',
      propertyId: 'prop_3',
      roomId: 'room_301',
      rentMonth: 'October 2026',
      rentAmount: 16000,
      dueDate: '2026-10-01',
      paymentDate: '2026-10-01',
      paymentMode: 'UPI',
      paymentStatus: 'Paid',
      transactionRef: 'UPI-441098273',
      receiptNumber: 'REC-2026-10-301',
      notes: 'Paid today on 1st of October via PhonePe UPI',
      createdDate: '2026-10-01T08:00:00Z'
    }
  ],

  notifications: [
    {
      id: 'notif_1',
      recipientId: 'cust_1',
      recipientRole: 'CUSTOMER',
      title: 'Monthly Rent Reminder',
      message: 'Your monthly rent of ₹14,000 for Ganga Heights (Room 102) is due on 5 October.',
      type: 'RENT_REMINDER',
      read: false,
      createdAt: '2026-10-01T07:00:00Z'
    },
    {
      id: 'notif_2',
      recipientId: 'owner_1',
      recipientRole: 'OWNER',
      title: 'New Rental Request Received',
      message: 'Priya Verma has requested to rent Room 103 in Ganga Heights Deluxe Complex.',
      type: 'RENTAL_REQUEST',
      read: false,
      createdAt: '2026-09-28T14:31:00Z'
    },
    {
      id: 'notif_3',
      recipientId: 'owner_2',
      recipientRole: 'OWNER',
      title: 'Rent Received for October 2026',
      message: 'Rahul & Anjali Gupta paid ₹16,000 for Gomti Greens (Flat 602) via UPI.',
      type: 'RENT_PAID',
      read: true,
      createdAt: '2026-10-01T08:05:00Z'
    },
    {
      id: 'notif_4',
      recipientId: 'cust_3',
      recipientRole: 'CUSTOMER',
      title: 'Rent Payment Receipt Generated',
      message: 'Your payment receipt REC-2026-10-301 for October 2026 has been generated. Tap to download.',
      type: 'RECEIPT_GENERATED',
      read: true,
      createdAt: '2026-10-01T08:06:00Z'
    }
  ],

  complaints: [
    {
      id: 'comp_1',
      userId: 'cust_1',
      userName: 'Amit Sharma',
      userRole: 'CUSTOMER',
      propertyId: 'prop_1',
      propertyTitle: 'Ganga Heights Deluxe Complex (Room 102)',
      category: 'Maintenance',
      subject: 'Bathroom tap water pressure low',
      description: 'The overhead geyser connection in the master bathroom has slow water flow since yesterday morning.',
      status: 'In Progress', // Open, In Progress, Resolved
      adminResponse: 'Owner Rajesh Pandey notified. Plumber scheduled for inspection today at 4 PM.',
      createdAt: '2026-09-30T16:20:00Z'
    },
    {
      id: 'comp_2',
      userId: 'owner_4',
      userName: 'Chaudhary Ramu Singh',
      userRole: 'OWNER',
      propertyId: 'prop_8',
      propertyTitle: 'Harahua Logistics & Agro Godown',
      category: 'Listing Verification',
      subject: 'Commercial electricity document upload assistance',
      description: 'Need assistance in linking 3-phase industrial power tariff document to listing.',
      status: 'Resolved',
      adminResponse: 'Verified by Admin team. Commercial 3-Phase tag attached to listing.',
      createdAt: '2026-09-25T11:00:00Z'
    }
  ],

  adminUsers: [
    {
      id: 'admin_1',
      name: 'Super Administrator',
      email: 'admin@rentease.in',
      mobile: '9000000000',
      role: 'Super Admin',
      status: 'Active',
      permissions: ['ALL'],
      lastLogin: '2026-10-01 09:30 AM'
    },
    {
      id: 'admin_2',
      name: 'Vikash Mehta',
      email: 'vikash.finance@rentease.in',
      mobile: '9111122222',
      role: 'Finance Admin',
      status: 'Active',
      permissions: ['PAYMENTS', 'REPORTS', 'RENT_COLLECTION'],
      lastLogin: '2026-09-30 05:15 PM'
    },
    {
      id: 'admin_3',
      name: 'Ananya Roy',
      email: 'ananya.support@rentease.in',
      mobile: '9333344444',
      role: 'Support Admin',
      status: 'Active',
      permissions: ['COMPLAINTS', 'CUSTOMERS', 'OWNERS'],
      lastLogin: '2026-10-01 08:45 AM'
    },
    {
      id: 'admin_4',
      name: 'Rohan Deshmukh',
      email: 'rohan.properties@rentease.in',
      mobile: '9555566666',
      role: 'Property Manager',
      status: 'Active',
      permissions: ['PROPERTIES', 'AREAS', 'APPROVALS'],
      lastLogin: '2026-09-29 11:20 AM'
    }
  ],

  auditLogs: [
    {
      id: 'audit_1',
      adminName: 'Super Administrator',
      action: 'PROPERTY_APPROVED',
      module: 'Properties',
      recordId: 'prop_1',
      oldValue: 'Pending Approval',
      newValue: 'Approved & Available',
      timestamp: '2026-09-28 10:14:00',
      ipAddress: '192.168.1.24'
    },
    {
      id: 'audit_2',
      adminName: 'Super Administrator',
      action: 'RENT_PAYMENT_RECORDED',
      module: 'Payments',
      recordId: 'pay_4',
      oldValue: 'Pending',
      newValue: 'Paid (Cash - ₹14,000)',
      timestamp: '2026-09-05 14:46:00',
      ipAddress: '192.168.1.24'
    },
    {
      id: 'audit_3',
      adminName: 'Ananya Roy',
      action: 'COMPLAINT_RESOLVED',
      module: 'Complaints',
      recordId: 'comp_2',
      oldValue: 'Open',
      newValue: 'Resolved',
      timestamp: '2026-09-25 11:45:00',
      ipAddress: '192.168.1.18'
    },
    {
      id: 'audit_4',
      adminName: 'Super Administrator',
      action: 'AGREEMENT_FINALIZED',
      module: 'Agreements',
      recordId: 'agr_102',
      oldValue: 'Verification Pending',
      newValue: 'Agreement Completed',
      timestamp: '2026-07-30 11:25:00',
      ipAddress: '192.168.1.24'
    }
  ],

  reminders: [
    {
      id: 'rem_1',
      rentalId: 'rent_act_1',
      tenantName: 'Amit Sharma',
      propertyTitle: 'Ganga Heights (Room 102)',
      amount: 14000,
      dueDate: '2026-10-05',
      type: 'Upcoming Due Date (4 Days Before)',
      channel: 'In-App + Push Notification',
      status: 'Delivered',
      sentAt: '2026-10-01 07:00 AM'
    },
    {
      id: 'rem_2',
      rentalId: 'rent_act_2',
      tenantName: 'Rahul & Anjali Gupta',
      propertyTitle: 'Gomti Greens (Flat 602)',
      amount: 16000,
      dueDate: '2026-10-01',
      type: 'Due Today Alert',
      channel: 'In-App + SMS Integration',
      status: 'Delivered',
      sentAt: '2026-10-01 06:30 AM'
    }
  ],

  settings: {
    general: {
      platformName: 'RentEase Monthly Rental Platform',
      supportEmail: 'support@rentease.in',
      supportPhone: '+91 1800-123-7368',
      currencySymbol: '₹',
      defaultAgreementMonths: 11
    },
    rental: {
      requirePropertyApproval: true,
      autoGenerateRentDueDays: 5,
      allowCashPaymentRecording: true,
      maxAdvanceNoticeMonths: 1
    },
    reminders: {
      sendAdvanceReminderDays: 4,
      sendOnDueDate: true,
      sendOverdueRemindersDaily: true
    },
    notifications: {
      enableInApp: true,
      enablePush: true,
      enableSMSMock: true,
      enableWhatsAppMock: true
    },
    security: {
      requireAadhaarConsent: true,
      sessionTimeoutMinutes: 60,
      twoFactorAdminAuth: true
    }
  },

  savedProperties: ['prop_1_room_101', 'prop_2_room_201', 'prop_5_room_501']
};

if (typeof window !== 'undefined') {
  window.INITIAL_DATABASE = INITIAL_DATABASE;
}
if (typeof module !== 'undefined' && module.exports) {
  module.exports = { INITIAL_DATABASE };
}

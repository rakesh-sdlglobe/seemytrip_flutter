# Traveller Form API Endpoints

This document shows which APIs are triggered when using the traveller forms.

## Base URL
- **Development**: `http://10.0.2.2:3002`
- **Production**: `https://tripadmin.seemytrip.com` (commented out)

---

## API Endpoints

### 1. **Add/Save Traveller** 
**Triggered when:** Clicking "Save Traveller" or "Add Guest" button

**Endpoint:**
```
POST /api/users/addTraveler
```

**Full URL:**
- Dev: `http://10.0.2.2:3002/api/users/addTraveler`
- Prod: `https://tripadmin.seemytrip.com/api/users/addTraveler`

**Headers:**
```json
{
  "Content-Type": "application/json",
  "Authorization": "Bearer {accessToken}",
  "Accept": "application/json"
}
```

**Request Body:**
```json
{
  "passengerName": "John Doe",
  "passengerMobileNumber": "1234567890",
  "passengerBerthChoice": "LB",  // LB, MB, UB, SL, SU, NP
  "passengerAge": 25,
  "passengerGender": "M",  // M, F, O
  "passengerNationality": "IN",
  "pasenger_dob": "2000-01-01",
  "passengerFoodChoice": "Veg"  // Veg, Non-Veg
}
```

**Response (Success - 200/201):**
```json
{
  "passengerId": 123,
  "message": "Traveller added successfully!"
}
```

**Called from:**
- Train: `TravellerDetailScreen` → `_handleSave()` → `travellerController.saveTravellerDetails()`
- Hotel: `BookingPreviewPage` → "Add Guest" button → `travellerController.saveTravellerDetails()`

---

### 2. **Fetch Travellers List**
**Triggered when:** 
- Screen loads (in `onInit()`)
- After successfully adding a traveller
- When navigating to traveller management screen

**Endpoint:**
```
GET /api/users/getTravelers
```

**Full URL:**
- Dev: `http://10.0.2.2:3002/api/users/getTravelers`
- Prod: `https://tripadmin.seemytrip.com/api/users/getTravelers`

**Headers:**
```json
{
  "Content-Type": "application/json",
  "Authorization": "Bearer {accessToken}"
}
```

**Response (Success - 200):**
```json
[
  {
    "passengerId": 123,
    "passengerName": "John Doe",
    "passengerMobileNumber": "1234567890",
    "passengerAge": 25,
    "passengerGender": "M",
    "passengerBerthChoice": "LB",
    "passengerFoodChoice": "Veg",
    "passengerNationality": "IN",
    "dob": "2000-01-01"
  },
  ...
]
```

**Called from:**
- `TravellerDetailController.onInit()`
- `TravellerDetailController.saveTravellerDetails()` (after successful save)
- `BookingPreviewPage._fetchUserContactDetails()`

---

## Authentication

Both APIs require:
- **Access Token** stored in `SharedPreferences` with key `'accessToken'`
- Token is retrieved from: `SharedPreferences.getInstance().getString('accessToken')`
- If token is missing, user is prompted to login

---

## Error Handling

### Common Error Scenarios:
1. **No Token**: Shows "Please login to add traveler"
2. **Network Error**: Shows "Network error. Please check your connection."
3. **Timeout**: Shows "Connection timed out. Please try again."
4. **Server Error**: Shows error message from server response
5. **Validation Error**: Shows field-specific validation messages

---

## Data Flow

### Adding a Traveller:
1. User fills form → Clicks "Save" or "Add Guest"
2. Form validates → `_formKey.currentState!.validate()`
3. Get form data → `_widgetKey.currentState?.getFormData()`
4. Call API → `travellerController.saveTravellerDetails(...)`
5. POST to `/api/users/addTraveler`
6. On success → Refresh list → `fetchTravelers()`
7. Update UI → Show success message

### Fetching Travellers:
1. Screen loads → `onInit()` or manual call
2. Call API → `travellerController.fetchTravelers()`
3. GET from `/api/users/getTravelers`
4. Parse response → Map to local data structure
5. Update observable → `travellers.value = ...`
6. UI updates automatically (using `Obx()`)

---

## Field Mappings

### Form Data → API Request:
- `name` → `passengerName`
- `age` → `passengerAge` (converted to int)
- `gender` → `passengerGender` (converted: Male→M, Female→F, Other→O)
- `mobile` → `passengerMobileNumber`
- `berthPreference` → `passengerBerthChoice` (converted: "Lower Berth"→"LB")
- `foodPreference` → `passengerFoodChoice`

### API Response → Form Data:
- `passengerName` → `name` / `passengerName`
- `passengerAge` → `age` / `passengerAge`
- `passengerGender` → `gender` / `passengerGender`
- `passengerMobileNumber` → `mobile` / `phone`
- `passengerBerthChoice` → `berthPreference` (converted back to full name)
- `passengerFoodChoice` → `foodPreference`

---

## Usage Examples

### Train Screen:
```dart
// Save traveller
await travellerController.saveTravellerDetails(
  name: 'John Doe',
  age: '25',
  gender: 'Male',
  mobile: '1234567890',
  berthPreference: 'Lower Berth',
  foodPreference: 'Veg',
);
```

### Hotel Screen:
```dart
// Add guest (simpler - no berth/food preferences)
await travellerController.saveTravellerDetails(
  name: 'Jane Doe',
  age: '30',
  gender: 'Female',
  mobile: '',  // Optional for hotel guests
  berthPreference: '',  // Not needed for hotels
  foodPreference: '',  // Not needed for hotels
);
```

---

## Notes

- The same API endpoint is used for all travel types (train, bus, hotel, flight)
- The API accepts all fields but some are optional depending on travel type
- Default values are used for missing optional fields:
  - Mobile: `'0000000000'`
  - Age: `18`
  - Gender: `'M'`
  - Nationality: `'IN'`
  - DOB: `'2000-01-01'`
  - Berth: `'LB'`
  - Food: `'Veg'`


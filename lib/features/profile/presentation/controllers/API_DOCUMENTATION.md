# Notification API Documentation

## Current Status
The notification system is currently using **mock data** for testing. The error you're seeing is because the API endpoint doesn't exist yet.

## What You Need to Implement

### 1. API Endpoint
```
GET /api/notifications
Authorization: Bearer <jwt_token>
```

### 2. Expected Response Format
```json
{
  "success": true,
  "message": "Notifications fetched successfully",
  "data": [
    {
      "id": "1",
      "title": "Booking Confirmed!",
      "subtitle": "Flight Booking",
      "body": "Your flight from Delhi to Mumbai has been confirmed. Booking ID: FL123456",
      "type": "booking",
      "is_read": false,
      "created_at": "2024-01-15T10:30:00Z",
      "data": {
        "booking_id": "FL123456"
      }
    },
    {
      "id": "2",
      "title": "Payment Successful",
      "subtitle": "Credit Card Transaction", 
      "body": "Payment of ₹15,000 has been processed successfully for your hotel booking.",
      "type": "payment",
      "is_read": false,
      "created_at": "2024-01-15T08:30:00Z",
      "data": {
        "transaction_id": "TXN789012"
      }
    }
  ]
}
```

### 3. Field Descriptions

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `id` | string | Yes | Unique notification ID |
| `title` | string | Yes | Main notification title |
| `subtitle` | string | No | Secondary text (e.g., "Flight Booking") |
| `body` | string | No | Detailed notification message |
| `type` | string | Yes | Notification type: `booking`, `payment`, `cancellation`, `reminder`, `promotion` |
| `is_read` | boolean | Yes | Whether user has read this notification |
| `created_at` | string | Yes | ISO 8601 timestamp |
| `data` | object | No | Additional data for navigation (e.g., booking_id, transaction_id) |

### 4. Additional Endpoints Needed

#### Mark as Read
```
PUT /api/notifications/{id}/read
Authorization: Bearer <jwt_token>
```

#### Mark All as Read
```
PUT /api/notifications/mark-all-read
Authorization: Bearer <jwt_token>
```

#### Delete Notification
```
DELETE /api/notifications/{id}
Authorization: Bearer <jwt_token>
```

## How to Switch to Real API

1. **Implement the backend API** with the above format
2. **Change the toggle** in `NotificationController`:
   ```dart
   static const bool useMockData = false; // Change to false
   ```
3. **Test the API** - the app will automatically use real data

## Current Mock Data

The app currently shows these sample notifications:
- ✅ Booking Confirmed (Flight)
- ✅ Payment Successful (Hotel)
- ✅ Booking Cancelled (Train) - Read
- ✅ Check-in Reminder (Hotel)
- ✅ Special Offer (Promotion) - Read

## Testing

- **Pull to refresh** works
- **Mark as read** works
- **Time display** works (5 min ago, 2 hours ago, etc.)
- **Different notification types** with appropriate icons
- **Dark/Light theme** support

The notification system is fully functional with mock data and ready for real API integration!

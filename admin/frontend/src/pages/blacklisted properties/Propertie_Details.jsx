import React from 'react';
import { Box, Typography, TextField, Card, CardMedia } from '@mui/material';

function Propertie_Details({ property }) {
  if (!property) return null;

  return (
    <Box sx={{ padding: '20px', border: '1px solid #ccc', borderRadius: '8px' }}>
      <Typography variant="h6" component="h2" gutterBottom>
        Property Details
      </Typography>
      <Card sx={{ maxWidth: 300, margin: 'auto' }}>
        <CardMedia
          component="img"
          height="200"
          image={property.photoUrl}
          alt="Property Photo"
        />
      </Card>
      <TextField
        label="Description"
        value={property.description}
        fullWidth
        margin="normal"
        InputProps={{ readOnly: true }}
      />
      <TextField
        label="Property Type"
        value={property.propertyType}
        fullWidth
        margin="normal"
        InputProps={{ readOnly: true }}
      />
       <TextField
        label="Room Type"
        value={property.roomType}
        fullWidth
        margin="normal"
        InputProps={{ readOnly: true }}
      />
      <TextField
        label="Price Per Night"
        value={property.pricePerNight}
        fullWidth
        margin="normal"
        InputProps={{ readOnly: true }}
      />
      <TextField
        label="Country"
        value={property.country}
        fullWidth
        margin="normal"
        InputProps={{ readOnly: true }}
      />
      <TextField
        label="City"
        value={property.city}
        fullWidth
        margin="normal"
        InputProps={{ readOnly: true }}
      />
      <TextField
        label="Max Guests"
        value={property.maxGuests}
        fullWidth
        margin="normal"
        InputProps={{ readOnly: true }}
      />
      <TextField
        label="Amenities"
        value={property.amenities}
        fullWidth
        margin="normal"
        InputProps={{ readOnly: true }}
      />
      
    </Box>
  );
}

export default Propertie_Details;

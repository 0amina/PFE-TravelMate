import React from 'react'
import { Box, Typography, TextField, Card, CardMedia } from '@mui/material';

function Hostedtails({ host }) {
    if (!host) return null;
  return (
    <Box sx={{ padding: '20px', border: '1px solid #ccc', borderRadius: '8px' }}>
    <Typography variant="h6" component="h2" gutterBottom>
     host Details
    </Typography>
    
    <Card 
      sx={{ 
        maxWidth: 300, 
        margin: 'auto', 
        display: 'flex', 
        justifyContent: 'center', 
        alignItems: 'center', 
        padding: 2 
      }}
    >
      <Box
        sx={{
          width: 150,
          height: 150,
          borderRadius: '50%',
          overflow: 'hidden',
          border: '2px solid #ccc',
          display: 'flex',
          justifyContent: 'center',
          alignItems: 'center',
        }}
      >
        <CardMedia
          component="img"
          image={host.photoUrl}
          
          sx={{ 
            width: '100%', 
            height: '100%', 
            objectFit: 'cover' 
          }}
        />
      </Box>
    </Card>
    
    <TextField
      label="Nom & Prenom"
      value={host.nomprenom}
      fullWidth
      margin="normal"
      InputProps={{ readOnly: true }}
    />
     <TextField
      label="Email"
      value={host.email}
      fullWidth
      margin="normal"
      InputProps={{ readOnly: true }}
    />
        <TextField
      label="Phone Number"
      value={host.phone}
      fullWidth
      margin="normal"
      InputProps={{ readOnly: true }}
    />
  
    
  </Box>
);
  
}

export default Hostedtails
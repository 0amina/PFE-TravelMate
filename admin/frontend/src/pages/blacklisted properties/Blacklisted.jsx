import React, { useState } from 'react';
import Box from '@mui/material/Box';
import { DataGrid } from '@mui/x-data-grid';
import { Button, IconButton, Typography } from '@mui/material';
import HouseIcon from '@mui/icons-material/House';
import Modal from '@mui/material/Modal';
import VisibilityIcon from '@mui/icons-material/Visibility';
import Propertie_Details from './Propertie_Details';
import { Height } from '@mui/icons-material';



const style = {
    position: 'absolute',
    
    top: '50%',
    left: '50%',
    transform: 'translate(-50%, -50%)',
    width: 700,
    bgcolor: 'background.paper',
    border: '2px solid #000',
    boxShadow: 24,
    p: 4,
  };


  
  const rows = [
      { id: 1, titlepropertie: 'Villa nassr', firstName: 'Pablo Escobar'},
      { id: 2, titlepropertie: 'Sokra dar', firstName: 'Ali hafsi' },
    ];
    
    function Blacklisted() {
        const [open, setOpen] = React.useState(false);
        const [selectedProperty, setSelectedProperty] = React.useState(null);
      
        const handleOpen = (property) => {
          setSelectedProperty(property);
          setOpen(true);
        };
      
        const handleClose = () => {
          setOpen(false);
          setSelectedProperty(null);
        };
      
  
        const columns = [
          { field: 'id', headerName: 'ID', width: 90 },
          {
            field: 'titlepropertie',
            headerName: 'Title Propertie',
            width: 180,
            editable: true,
          },
          {
            field: 'Propritaire',
            headerName: 'Propritaire',
            description: 'This column has a value getter and is not sortable.',
            sortable: false,
            width: 300,
            valueGetter: (_value, row) => `${row.firstName || ''} ${row.lastName || ''}`,
          },
          {
            width: 150,
            renderCell: (params) => (
                <div style={{ display: 'flex', alignItems: 'center' }}>
                <IconButton
                 
                 onClick={handleOpen} 
                   
                  
                  sx={{ marginRight: 5 }} 
                >
                  <VisibilityIcon />
                </IconButton>
                <Button
                  variant="contained"
                  sx={{
                    backgroundColor: 'green',
                    '&:hover': {
                      backgroundColor: 'darkgreen',
                    },
                  }}
                >
                  Activé
                </Button>
              </div>
            ),
          },
          
          
        
             
            
          
        ];

  return (
    <Box sx={{
      width: '100%',
      height: '500px', // Set the same height for both grids
      overflowX: 'auto', // Enable horizontal scrolling on smaller screens
    }}>
      <Box
        sx={{
          padding: '20px', // Adjust padding for smaller screens
        }}
      >
        <h2>Blacklisted Properties</h2>
        <div style={{ height: '300px', maxWidth: '100%' }}> {/* Set max width to 100% */}
          <DataGrid
            rows={rows}
            columns={columns}
            initialState={{
              pagination: {
                paginationModel: {
                  pageSize: 5,
                },
              },
            }}
            pageSizeOptions={[5]}
            checkboxSelection
            disableRowSelectionOnClick
            sx={{
              '& .MuiDataGrid-columnHeaders': {
              },
              '& .MuiDataGrid-columnHeaderTitle': {
                color: '',
                fontWeight: 'bold',
                fontSize: '20px'
              },
              '& .MuiDataGrid-cell': {
                padding: '5px',
                fontSize: '16px',
              },
              '& .MuiDataGrid-row': {
                minHeight: '60px',
              },
            }}
          />
        </div>
        <Modal open={open} onClose={handleClose} >
          <Box sx={style}>
            <Typography variant="h6" component="h2" sx={{ml:25, fontFamily:"inherit",fontSize:26 ,color:"orange", fontWeight:"bold"} }>
              Propertie Details
            </Typography>
            <Propertie_Details property={selectedProperty} />
          </Box>
        </Modal>
      </Box>
    </Box>
  );
}

export default Blacklisted;

import React from 'react';
import Box from '@mui/material/Box';
import { DataGrid } from '@mui/x-data-grid';
import { Button } from '@mui/material';
import CheckIcon from '@mui/icons-material/Check';
import CloseIcon from '@mui/icons-material/Close';

function Pneding() {
  const columns = [
    { field: 'id', headerName: 'ID', width: 90 },
    {
      field: 'postdesciption',
      headerName: 'Post Description',
      width: 200,
      editable: true,
    },
    {
      field: 'host',
      headerName: 'Host',
      description: 'This column has a value getter and is not sortable.',
      sortable: false,
      width: 700,
      valueGetter: (_value, row) => `${row.firstName || ''} ${row.lastName || ''}`,
    },
    {
      width: 300, 
      renderCell: (params) => (
        <div>
          <Button
            variant="contained"
            startIcon={<CheckIcon />} 
            sx={{
              backgroundColor: 'green',
              '&:hover': {
                backgroundColor: 'darkgreen',
              },
            }}
            onClick={(event) =>{
                event.stopPropagation(),

                 handleAccept(params.row.id)}} // Implement accept logic
          >
            Accepter
          </Button>
          <Button
            variant="contained"
            startIcon={<CloseIcon />} 
            sx={{
              marginLeft: '10px', 
              backgroundColor: 'red',
              '&:hover': {
                backgroundColor: 'darkred',
              },
            }}
            onClick={(event) =>{
                event.stopPropagation(),
                handleDecline(params.row.id);}} // Implement decline logic
          >
            Refuser
          </Button>
        </div>
      ),
    },
  ];
  
  const rows = [
    { id: 1, postdesciption: 'Villa nassr', firstName: 'Pablo Escobar'},
    { id: 2, postdesciption: 'Sokra dar', firstName: 'Ali hafsi' },
  ];

  return (
    <Box sx={{
      width: '100%',
      overflowX: 'auto', // Enable horizontal scrolling on smaller screens
    }}>
      <Box
        sx={{
          padding: '20px', // Adjust padding for smaller screens
        }}
      >
        <h2>Pending Posts</h2>
        <div style={{ height: 500, maxWidth: '100%' }}> {/* Set max width to 100% */}
          <DataGrid
            rows={rows}
            // @ts-ignore
            columns={columns}
            pageSize={5} // Set page size directly
            disableSelectionOnClick
            checkboxSelection
            sx={{
              '& .MuiDataGrid-columnHeaderTitle': {
                fontWeight: 'bold',
                fontSize: '20px',
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
      </Box>
    </Box>
  );
}

export default Pneding;
function handleAccept(id) {
    throw new Error('Function not implemented.');
}

function handleDecline(id) {
    throw new Error('Function not implemented.');
}


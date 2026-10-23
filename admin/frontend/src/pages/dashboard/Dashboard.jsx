import React from "react";
import {
  Box,
  Typography,
  Grid,
} from "@mui/material";

import StatBox from "pages/stattbox/StatBox";
import Piechart from "pages/piechart/Piechart";
import Blacklisted from "pages/blacklisted properties/Blacklisted";
import Pneding from "pages/pending posts/Pneding";

function Dashboard() {
  // Supposons que vous ayez déjà les données pour vos statistiques
  const hosts = 18;
  const blacklisted = 3;
  const newUsers = 10;
  const disabledCards = 2;

  return (
    <Box m={2}>
      <Box
        display="flex"
        justifyContent="space-between"
        alignItems="center"
      >
        <Typography variant="h5" fontWeight="bold" color="white">
          Dashboard
        </Typography>
      </Box>

      <Grid container spacing={5} mt={3}>
        <Grid item xs={12} sm={6} md={3}>
          <Box
            bgcolor="#424242" // Change to desired background color
            p={2}
            borderRadius={10}
            textAlign="center"
            display="flex"
            justifyContent="center"
            sx={{
              transition: "background-color 0.3s",
              "&:hover": { bgcolor: "#303030" }, // Change to desired hover color
            }}
          >
            <StatBox
              title={hosts}
              subtitle={<Typography
                variant="h5"
                style={{ color: "lightblue", fontWeight: "bold" }}
              >
                Hosts
              </Typography>}
              progress={3}
              increase="+5%" icon={undefined}            
            />
          </Box>
        </Grid>

        <Grid item xs={12} sm={6} md={3}>
          <Box
            bgcolor="#424242" // Change to desired background color
            p={2}
            borderRadius={10}
            textAlign="center"
            display="flex"
            justifyContent="center"
            sx={{
              transition: "background-color 0.3s",
              "&:hover": { bgcolor: "#303030" }, // Change to desired hover color
            }}
          >
            <StatBox
              title={blacklisted}
              subtitle={<Typography
                variant="h5"
                style={{ color: "skyblue", fontWeight: "bold" }}
              >
               Blacklisted Properties
              </Typography>}
              progress={5}
              increase="+10%" icon={undefined}             
            />
          </Box>
        </Grid>

        <Grid item xs={12} sm={6} md={3}>
          <Box
            bgcolor="#424242" // Change to desired background color
            p={2}
            borderRadius={10}
            textAlign="center"
            display="flex"
            justifyContent="center"
            sx={{
              transition: "background-color 0.3s",
              "&:hover": { bgcolor: "#303030" }, // Change to desired hover color
            }}
          >
            <StatBox
              title={newUsers}
              subtitle={<Typography
                variant="h5"
                style={{ color: "skyblue", fontWeight: "bold" }}
              >
                Pending Posts
              </Typography>}
              progress={2}
              increase="+20%" icon={undefined}              
            />
          </Box>
        </Grid>

        <Grid item xs={12} sm={6} md={3}>
          <Box
            bgcolor="#424242" // Change to desired background color
            p={2}
            borderRadius={10}
            textAlign="center"
            display="flex"
            justifyContent="center"
            sx={{
              transition: "background-color 0.3s",
              "&:hover": { bgcolor: "#303030" }, // Change to desired hover color
            }}
          >
            <StatBox
              title={disabledCards}
              subtitle={<Typography
                variant="h5"
                style={{ color: "skyblue", fontWeight: "bold" }}
              >
               Decline Posts
              </Typography>}
              progress={1}
              increase="-50%" icon={undefined}            />
          </Box>
        </Grid>
      </Grid>

      <Grid container spacing={2}>
  <Grid item xs={12} md={6}>
    <Box bgcolor="lightblack" borderRadius={10} p={2} sx={{ height: '100%' }}>
      <Typography variant="h5" fontWeight="bold" color="white" mb={2}>
        Blacklisted Properties
      </Typography>
      <Blacklisted />
    </Box>
  </Grid>

  <Grid item xs={12} md={6}>
  <Box sx={{ position: 'relative', height: '100%' }}>
  <Box sx={{ position: 'absolute', top: 10, right: 10 }}>
    <Typography variant="h6" fontWeight="bold" color="white">
      Declined post & Accepted posts
    </Typography>
  </Box>
  <Piechart />
</Box>
  </Grid>
</Grid>
    </Box>
  );
}

export default Dashboard;

import React from 'react';
import { PieChart, Pie, Tooltip, Cell, Legend } from 'recharts';
import { Box } from '@mui/material';
import { mockPieData } from './data';

function Piechart() {
  const COLORS = ['#FF1DCE', '#66FF00']; // Couleurs vives pour les tranches du graphique

  return (
    <Box mt={9} height={700} display="flex" justifyContent="center" >
      <PieChart width={400} height={500}>
        <Pie
          data={mockPieData}
          dataKey="value"
          nameKey="label"
          innerRadius={70}
          outerRadius={200}
          label={({ name, value }) => ` ${value}`} // Display label with name and value
        >
          {mockPieData.map((entry, index) => (
            <Cell key={`cell-${index}`} fill={COLORS[index % COLORS.length]} />
          ))}
        </Pie>
        <Tooltip />
        <Legend verticalAlign="bottom" height={8} /> {/* Add Legend component */}
      </PieChart>
    </Box>
  );
}

export default Piechart;

import React from 'react';
import { Box, useTheme } from '@mui/material';

function ProgressCircle({ progress = 0.75, size = "40" }) {
  const theme = useTheme();
  const angle = progress * 360;
  return (
    <Box
      sx={{
        background: `radial-gradient(${theme.palette.grey[800]} 55%, transparent 56%),
            conic-gradient(transparent 0deg ${angle}deg, #FF1DCE ${angle}deg 360deg),
            #66FF00`,
        borderRadius: "50%",
        width: `${size}px`,
        height: `${size}px`,
      }}
    />
  );
}

export default ProgressCircle;

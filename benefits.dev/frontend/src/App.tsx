import React from 'react';
import { Container, CssBaseline, ThemeProvider, createTheme } from '@mui/material';
import LogViewer from './components/LogViewer';

const theme = createTheme({
  palette: {
    mode: 'light',
  },
});

function App() {
  return (
    <ThemeProvider theme={theme}>
      <CssBaseline />
      <Container maxWidth="lg">
        <LogViewer />
      </Container>
    </ThemeProvider>
  );
}

export default App;

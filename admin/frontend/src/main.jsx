
import React from 'react'
import ReactDOM from 'react-dom/client'

import './index.css'



import {

  createBrowserRouter,
  createRoutesFromElements,
  Route,
  RouterProvider,
  

} from "react-router-dom";
import App from './App';
import Dashboard from './pages/dashboard/Dashboard';

import Piechart from './pages/piechart/Piechart';
import Blacklisted from './pages/blacklisted properties/Blacklisted';
import Pneding from 'pages/pending posts/Pneding';
import HosteBlacklisted from 'pages/hosts/HosteBlacklisted';






const router = createBrowserRouter(
  createRoutesFromElements(
    
        <Route path='/'element={<App/>} >
           <Route index element={< Dashboard />} />
           <Route path='blacklistedhost' element={<HosteBlacklisted/>} />
           <Route path='blacklisteprop' element={<Blacklisted/>} />
           <Route path='pendingposts' element={<Pneding/>} />
           <Route path='pie' element= {<Piechart/>}/>
           
       
        </Route>
  )
);
ReactDOM.createRoot(document.getElementById('root')).render(
  <React.StrictMode>
   
     <RouterProvider router={router}/>
    
  </React.StrictMode>,
)

import React from 'react'
import './App.css'
import {
  BrowserRouter as Router,
  Switch,
  Route,
} from 'react-router-dom'

import { Restaurants } from './containers/Restaurants'
import { Orders } from './containers/Orders'
import { Foods } from './containers/Foods'

function App() {
  return (
    <Router>
      <Switch>
        <Route exact path="/restaurants" component={Restaurants} />
        <Route exact path="/restaurants/:restaurantsId/foods" component={Foods} />
        <Route exact path="/orders" component={Orders} />
      </Switch>
    </Router>
  )
}

export default App;

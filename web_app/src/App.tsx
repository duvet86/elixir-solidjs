import { BrowserRouter as Router, Switch, Route } from "react-router-dom";

import { ProvideAuth } from "./services/authProvider";
import Home from "./pages/home/Home";
import Login from "./pages/login/Login";
import ProtectedRoute from "./components/routes/ProtectedRoute";

function App() {
  return (
    <ProvideAuth>
      <Router>
        <div>
          {/* <AuthButton /> */}
          <Switch>
            <Route path="/login">
              <Login />
            </Route>
            <ProtectedRoute path="/protected">
              <Home />
            </ProtectedRoute>
          </Switch>
        </div>
      </Router>
    </ProvideAuth>
  );
}

export default App;

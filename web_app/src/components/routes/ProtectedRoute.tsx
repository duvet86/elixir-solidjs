import { ReactElement } from "react";
import { Route, Redirect, RouteProps } from "react-router-dom";

import { useAuth } from "../../services/authProvider";

interface Props extends RouteProps {
  children: ReactElement;
}

export default function ProtectedRoute({ children, ...rest }: Props) {
  const auth = useAuth();

  return (
    <Route
      {...rest}
      render={({ location }) =>
        auth.user !== null ? (
          children
        ) : (
          <Redirect
            to={{
              pathname: "/login",
              state: { from: location },
            }}
          />
        )
      }
    />
  );
}

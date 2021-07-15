import { ReactElement } from "react";
import { Route, Redirect, RouteProps } from "react-router-dom";

import { useAuthState } from "../../services/authProvider";

interface Props extends RouteProps {
  children: ReactElement;
}

export default function ProtectedRoute({ children, ...rest }: Props) {
  const { token } = useAuthState();

  return (
    <Route
      {...rest}
      render={({ location }) =>
        token !== null ? (
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

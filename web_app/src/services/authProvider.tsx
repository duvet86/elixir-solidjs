import { useContext, createContext, useState, ReactElement } from "react";
import { postAync } from "./api";

interface Auth {
  user: string | null;
  signinAsync: (credentials: Credentials, cb: () => void) => void;
  signout: (cb: () => void) => void;
}

interface Credentials {
  email: string;
  password: string;
}

/** For more details on
 * `authContext`, `ProvideAuth`, `useAuth` and `useProvideAuth`
 * refer to: https://usehooks.com/useAuth/
 */
const authContext = createContext<Auth>({
  user: null,
  signinAsync: () => {},
  signout: () => {},
});

interface Props {
  children: ReactElement;
}

export function ProvideAuth({ children }: Props) {
  const auth = useProvideAuth();
  return <authContext.Provider value={auth}>{children}</authContext.Provider>;
}

export function useAuth() {
  return useContext(authContext);
}

function useProvideAuth() {
  const [user, setUser] = useState<string | null>(null);

  const signinAsync = async (credentials: Credentials, cb: () => void) => {
    await postAync("api/login", credentials);

    setUser("user");
    cb();
  };

  const signout = (cb: () => void) => {
    setUser(null);
    cb();
  };

  return {
    user,
    signinAsync,
    signout,
  };
}

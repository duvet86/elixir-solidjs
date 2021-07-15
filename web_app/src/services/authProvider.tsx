import {
  useContext,
  createContext,
  useState,
  ReactElement,
  useMemo,
} from "react";
import { postAync } from "./api";

interface AuthState {
  token: string | null;
}

interface AuthDispatch {
  signinAsync: (credentials: Credentials) => Promise<void>;
  signoutAsync: () => Promise<void>;
}

interface Credentials {
  email: string;
  password: string;
}

const AuthContextState = createContext<AuthState>({
  token: null,
});

const AuthContextDispatch = createContext<AuthDispatch>({
  signinAsync: () => Promise.resolve(),
  signoutAsync: () => Promise.resolve(),
});

interface Props {
  children: ReactElement;
}

export function ProvideAuth({ children }: Props) {
  const [token, setToken] = useState<string | null>(
    localStorage.getItem("TOKEN")
  );

  const authDispatch = useMemo<AuthDispatch>(
    () => ({
      signinAsync: async (credentials: Credentials) => {
        const { token } = await postAync<{ token: string }>(
          "api/login",
          credentials
        );

        localStorage.setItem("TOKEN", token);
        setToken(token);
      },
      signoutAsync: () => {
        localStorage.removeItem("TOKEN");
        setToken(null);

        return Promise.resolve();
      },
    }),
    []
  );

  return (
    <AuthContextDispatch.Provider value={authDispatch}>
      <AuthContextState.Provider value={{ token }}>
        {children}
      </AuthContextState.Provider>
    </AuthContextDispatch.Provider>
  );
}

export function useAuthState() {
  return useContext(AuthContextState);
}

export function useAuthDispatch() {
  return useContext(AuthContextDispatch);
}

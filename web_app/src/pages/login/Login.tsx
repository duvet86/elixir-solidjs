import { useRef, SyntheticEvent } from "react";
import { useHistory, useLocation, Redirect } from "react-router-dom";
import { useAuthDispatch, useAuthState } from "../../services/authProvider";

interface LocationState {
  from: { pathname: string };
}

export default function Login() {
  const history = useHistory();
  const location = useLocation<LocationState>();
  const { signinAsync } = useAuthDispatch();
  const { token } = useAuthState();

  const emailRef = useRef<HTMLInputElement | null>(null);
  const passwordRef = useRef<HTMLInputElement | null>(null);

  const { from } = location.state || { from: { pathname: "/" } };

  async function handleSubmit(event: SyntheticEvent) {
    if (emailRef.current === null || passwordRef.current === null) {
      throw Error();
    }

    event.preventDefault();

    const credentials = {
      email: emailRef.current.value,
      password: passwordRef.current.value,
    };

    await signinAsync(credentials);

    history.replace(from);
  }

  if (token !== null) {
    return <Redirect to="/" />;
  }

  return (
    <form onSubmit={handleSubmit}>
      <input type="text" ref={emailRef} defaultValue="jane.doe@example.com" />
      <input type="password" ref={passwordRef} defaultValue="password" />
      <button type="submit">Submit</button>
    </form>
  );
}

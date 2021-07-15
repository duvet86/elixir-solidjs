import { useHistory } from "react-router-dom";

import { useAuthDispatch } from "../services/authProvider";

export default function LogoutButton() {
  const history = useHistory();
  const { signoutAsync } = useAuthDispatch();

  async function handleClick() {
    await signoutAsync();
    history.push("/");
  }

  return (
    <p>
      Welcome! <button onClick={handleClick}>Sign out</button>
    </p>
  );
}

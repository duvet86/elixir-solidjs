import { useRef, SyntheticEvent } from "react";

export default function Login() {
  const emailRef = useRef<HTMLInputElement | null>(null);
  const passwordRef = useRef<HTMLInputElement | null>(null);

  function handleSubmit(event: SyntheticEvent) {
    event.preventDefault();

    fetch("api/login", {
      method: "POST",
      mode: "cors",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        email: emailRef.current?.value,
        password: passwordRef.current?.value,
      }),
    })
      .then((resp) => {
        if (!resp.ok) {
          throw resp;
        }
        return resp.json();
      })
      .then((data) => {
        console.log(data);
      })
      .catch((err) => console.error(err));
  }

  return (
    <form onSubmit={handleSubmit}>
      <input type="text" ref={emailRef} defaultValue="jane.doe@example.com" />
      <input type="password" ref={passwordRef} defaultValue="password" />
      <button type="submit">Submit</button>
    </form>
  );
}

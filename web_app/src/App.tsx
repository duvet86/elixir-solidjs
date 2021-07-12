import { Component, createSignal } from "solid-js";

const App: Component = () => {
  const [email, setEmail] = createSignal("");
  const [password, setPassword] = createSignal("");

  return (
    <>
      <h3>Login</h3>
      <input
        type="text"
        placeholder="Username"
        onInput={(e) => setEmail(e.currentTarget.value)}
      />
      <input
        type="password"
        placeholder="Password"
        onInput={(e) => setPassword(e.currentTarget.value)}
      />
      <button
        onClick={() => {
          fetch("api/login", {
            method: "POST",
            mode: "cors",
            headers: {
              "Content-Type": "application/json",
            },
            body: JSON.stringify({
              email: email(),
              password: password(),
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
        }}
      >
        Login
      </button>
    </>
  );
};

export default App;

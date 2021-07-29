import { useEffect } from "react";

import { getAync } from "../../services/api";
import LogoutButton from "../../components/LogoutButton";

export default function Home() {
  useEffect(() => {
    getAync("/api/vaccinations?location=italy").then((data) => {
      console.log(data);
    });
  }, []);

  return (
    <>
      <h3>Home</h3>
      <LogoutButton />
    </>
  );
}

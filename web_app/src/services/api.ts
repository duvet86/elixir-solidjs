export async function getAync<T>(url: string): Promise<T> {
  try {
    const resp = await fetch(url, {
      ...commonHeaders(),
      method: "GET",
    });

    return handleResponse(resp);
  } catch (err) {
    throw err;
  }
}

export async function postAync<T>(url: string, body: unknown): Promise<T> {
  try {
    const resp = await fetch(url, {
      ...commonHeaders(),
      method: "POST",
      body: JSON.stringify(body),
    });

    return handleResponse(resp);
  } catch (err) {
    throw err;
  }
}

function commonHeaders(): RequestInit {
  return {
    mode: "cors",
    headers: {
      "Content-Type": "application/json",
    },
  };
}

function handleResponse(resp: Response) {
  if (!resp.ok) {
    throw resp;
  }
  return resp.json();
}

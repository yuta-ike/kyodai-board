import AppUser from "./user"

export const mapUserData = (user: any): AppUser => {
  const { uid, email, xa } = user
  return {
    id: uid,
    email,
    token: xa,
  }
}

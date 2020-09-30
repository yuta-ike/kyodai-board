import Axios, { AxiosInstance } from "axios"
import { useEffect, useState } from "react"
import { useUser } from "./useUser"

Axios.interceptors.request.use(config => {
	if(config.headers.token == null) throw new Error('ユーザートークンが設定されていません')
	return config
})

const useAuthAPI = () => {
	const [state, setState] = useState<{ axios: AxiosInstance, key: (key: string) => string | null }>({ axios: Axios, key: x => x })
	const { user } = useUser()
	useEffect(() => {
		if(user != null){
			setState({
				axios: Axios.create({
					headers: {
						token: user.token,
						'Content-Type': 'application/json',
					},
					responseType: 'json',
				}),
				key: (key) => user.token != null ? `{key: "${key}", token: "${user.token}"}` : null,
			})
		}
	}, [user?.token])
	return state
}

export default useAuthAPI
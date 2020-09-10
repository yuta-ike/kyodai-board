import firebase from 'firebase/app';
import 'firebase/firestore';

const firebaseConfig = {
	apiKey: "AIzaSyAyM-KnbwFVYrJ7lBI0GpEcfYiBrzJY4oU",
	authDomain: "kyodai-board.firebaseapp.com",
	databaseURL: "https://kyodai-board.firebaseio.com",
	projectId: "kyodai-board",
	storageBucket: "kyodai-board.appspot.com",
	messagingSenderId: "937199683335",
	appId: "1:937199683335:web:929db4d776f89382c067a2",
	measurementId: "G-RDRYET89XN"
};

firebase.initializeApp(firebaseConfig);
export default firebase;
export const db = firebase.firestore();
import { createRemoteJWKSet } from "jose";
import { AppCheckTokenVerifier, type AppCheckIdentity } from "./app-check";
import { FirebaseIdTokenVerifier, type FirebaseIdentity } from "./firebase-id-token";
import { FirebasePublicKeyProvider } from "./firebase-public-keys";

const appCheckJwks = createRemoteJWKSet(new URL("https://firebaseappcheck.googleapis.com/v1/jwks"));
const firebasePublicKeys = new FirebasePublicKeyProvider();
const appCheckVerifiers = new Map<string, AppCheckTokenVerifier>();
const firebaseIdTokenVerifiers = new Map<string, FirebaseIdTokenVerifier>();

export function verifyAppCheckToken(
  token: string,
  projectNumber: string,
): Promise<AppCheckIdentity> {
  let verifier = appCheckVerifiers.get(projectNumber);
  if (!verifier) {
    verifier = new AppCheckTokenVerifier({ getKey: appCheckJwks, projectNumber });
    appCheckVerifiers.set(projectNumber, verifier);
  }
  return verifier.verify(token);
}

export function verifyFirebaseIdToken(token: string, projectId: string): Promise<FirebaseIdentity> {
  let verifier = firebaseIdTokenVerifiers.get(projectId);
  if (!verifier) {
    verifier = new FirebaseIdTokenVerifier({
      getKey: firebasePublicKeys.getKey,
      projectId,
    });
    firebaseIdTokenVerifiers.set(projectId, verifier);
  }
  return verifier.verify(token);
}

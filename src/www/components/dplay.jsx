import { Actor, HttpAgent } from '@dfinity/agent';
import { idlFactory as dplay_idl, canisterId as dplay_id } from 'dfx-generated/dplay';

const agent = new HttpAgent();
const DPlay = Actor.createActor(dplay_idl, { agent, canisterId: dplay_id});

export default DPlay;
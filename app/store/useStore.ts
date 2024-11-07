import { create } from 'zustand';

interface State {
  data: any;
  setData: (data: any) => void;
}
export const useStore = create<State>((set) => ({
  data: null,
  setData: (data: any) => set({ data }),
}));
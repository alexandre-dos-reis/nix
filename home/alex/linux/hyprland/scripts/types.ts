export type WindowInfo = {
  address: string;
  pid: number;
  class: string;
  workspace: {
    id: number;
    name: string;
  };
  floating: boolean;
  pseudo: boolean;
  monitor: number;
  title: string;
  initialClass: string;
  initialTitle: string;
};

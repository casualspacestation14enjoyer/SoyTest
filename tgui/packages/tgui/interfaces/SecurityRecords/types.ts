import { BooleanLike } from 'common/react';

export type SecurityRecordsData = {
  assigned_view: string;
  authenticated: BooleanLike;
  available_statuses: string[];
  current_user: string;
  records: SecurityRecord[];
  min_age: number;
  max_age: number;
};

export type SecurityRecord = {
  age: number;
  record_ref: string;
  crimes: Crime[];
  fingerprint: string;
  gender: string;
  name: string;
  security_note: string;
  rank: string;
  species: string;
  wanted_status: string;
};

export type Crime = {
  author: string;
  crime_ref: string;
  details: string;
  fine: number;
  name: string;
  paid: number;
  time: number;
};

export enum SECURETAB {
  Crimes,
  Citations,
  Add,
}

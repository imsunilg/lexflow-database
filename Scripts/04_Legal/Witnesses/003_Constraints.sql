ALTER TABLE legal.witnesses
  ADD CONSTRAINT ck_witnesses_exam_status CHECK (exam_status IN ('ToBeExamined', 'ChiefDone', 'CrossDone', 'Discharged'));

ALTER TABLE legal.witnesses
  ADD CONSTRAINT fk_witnesses_case FOREIGN KEY (case_id) REFERENCES legal.court_cases (id);

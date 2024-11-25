# Case study

Command to clone the repository:
git clone https://github.com/shjain11/data_etl.git



This repo contains 2 Files:

1- person_import.py

- A script to export 30K person data to the local directory in csv
- Script can be used to pass different parameter values to export the data from API
- Once the data is stored at a location, it can used to import to the database by file pattern to import the files in landing layer.
- This python file is executable.


2- person.sql

- This script set the masking policies to anonymize the PII.
- SQL to answer the questions and generate reports
- This SQL is non-executaable.

import requests
import csv
from datetime import datetime


def fetch_and_export_persons_data(quantity='30K', gender='XXX', birthday_start='1900-01-01'):
    """
    Fetches data from the Faker API and exports it to a CSV file.
    
    Parameters:
    - quantity (str): Number of persons to fetch (e.g., '30K').
    - gender (str): Gender to filter by (e.g., 'male', 'female', or 'XXX' for all).
    - birthday_start (str): The start date for the birthday range (e.g., '1900-01-01').

    Returns:
    - None
    """
    current_datetime = datetime.now()

    # URL of the API
    url = f"https://fakerapi.it/api/v2/persons?_quantity={quantity}&_gender={gender}&_birthday_start={birthday_start}"
    
    print(url)

    try:
        # Make a request to the API
        response = requests.get(url)
        
        # Check if the request was successful (status code 200)
        response.raise_for_status()

        # Parse the JSON response
        data = response.json()

        # Open a CSV file for writing
        file_name = f'persons_data_{current_datetime.strftime("%Y%m%d_%H%M%S")}.csv'
        with open(file_name, mode='w', newline='', encoding='utf-8') as file:
            writer = csv.DictWriter(file, fieldnames=['id', 'first_name', 'last_name', 'email', "phone", 'birthday', 'gender', 'address', 'website', 'image'])
            writer.writeheader()  # Write the header row

            # Write the data rows
            for person in data['data']:
                writer.writerow({
                    'id': person['id'],
                    'first_name': person['firstname'],
                    'last_name': person['lastname'],
                    'email': person['email'],
                    'phone': person['phone'],
                    'birthday': person['birthday'],
                    'gender': person['gender'],
                    'address': person['address'],
                    'website': person['website'],
                    'image': person['image']
                })

        print(f"Data has been exported to '{file_name}'.")

    except requests.exceptions.RequestException as e:
        print(f"Error while fetching data from the API: {e}")
    except requests.exceptions.HTTPError as e:
        print(f"HTTP error occurred: {e}")
    except requests.exceptions.ConnectionError as e:
        print(f"Connection error occurred: {e}")
    except requests.exceptions.Timeout as e:
        print(f"Request timeout occurred: {e}")
    except ValueError as e:
        print(f"Error parsing the response JSON: {e}")
    except IOError as e:
        print(f"Error writing to the CSV file: {e}")
    except Exception as e:
        print(f"An unexpected error occurred: {e}")


fetch_and_export_persons_data(quantity='30K', gender='male', birthday_start='1980-01-01')


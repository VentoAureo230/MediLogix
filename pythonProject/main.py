import csv
import psycopg2
import time
import random

# Database authentication
DB_HOST = 'localhost'
DB_NAME = 'medilogix'
DB_USER = 'postgres'
DB_PASSWORD = 'test'

def create_tables():
    try:
        connection = psycopg2.connect(
            host=DB_HOST,
            database=DB_NAME,
            user=DB_USER,
            password=DB_PASSWORD
        )
        cursor = connection.cursor()

        create_medicaments_table = """
        CREATE TABLE IF NOT EXISTS medications (
            medication_id SERIAL PRIMARY KEY,
            name VARCHAR(255) UNIQUE NOT NULL,
            quantity INT NOT NULL,
            availability VARCHAR(255) NOT NULL,
            category VARCHAR(255) NOT NULL,
            location VARCHAR(255) NOT NULL
        );
        """

        create_cip_codes_table = """
        CREATE TABLE IF NOT EXISTS cip_codes (
            cip_code_id SERIAL PRIMARY KEY,
            cip_code VARCHAR(255) UNIQUE NOT NULL,
            medication_id INT NOT NULL,
            FOREIGN KEY (medication_id) REFERENCES medications(medication_id) ON DELETE CASCADE
        );
        """

        cursor.execute(create_medicaments_table)
        cursor.execute(create_cip_codes_table)

        connection.commit()
        print("Tables créées avec succès.")

    except (Exception, psycopg2.Error) as error:
        print("Erreur lors de la création des tables", error)

    finally:
        if connection:
            cursor.close()
            connection.close()
            print("Connexion à PostgreSQL fermée.")

create_tables()

def insert_medications_from_csv(file_path):
    try:

        connection = psycopg2.connect(
            host=DB_HOST,
            database=DB_NAME,
            user=DB_USER,
            password=DB_PASSWORD
        )
        cursor = connection.cursor()

        insert_medicament_query = """
        INSERT INTO medications (name, quantity, availability, category, location)
        VALUES (%s, %s, %s, %s, %s)
        ON CONFLICT (name) DO NOTHING
        RETURNING medication_id;
        """

        insert_cip_code_query = """
        INSERT INTO cip_codes (cip_code, medication_id)
        VALUES (%s, %s)
        ON CONFLICT (cip_code) DO NOTHING;
        """

        with open(file_path, mode='r', encoding='ISO-8859-1') as csvfile:
            csv_reader = csv.reader(csvfile, delimiter=';')
            for row in csv_reader:
                if len(row) >= 3:
                    cip_code = row[1]
                    medicament = row[2] 

                    qtt = random.randint(0, 200)

                    if qtt == 0:
                        disponibilite = 'En rupture'
                    elif qtt <= 80:
                        disponibilite = 'Stock faible'
                    else:
                        disponibilite = 'En stock'

                    category = f"cat{random.randint(1, 10)}"
                    location = f"{chr(random.randint(65, 69))}{random.randint(1, 10)}"

                    cursor.execute(insert_medicament_query, (medicament, qtt, disponibilite, category, location))
                    medicament_id = cursor.fetchone()

                    if medicament_id is None:
                        cursor.execute("SELECT medication_id FROM medications WHERE name = %s", (medicament,))
                        medicament_id = cursor.fetchone()[0]
                    else:
                        medicament_id = medicament_id[0]

                    cursor.execute(insert_cip_code_query, (cip_code, medicament_id))

                    connection.commit()

                    delay = random.uniform(0, 1)
                    print(f"Données insérées pour le médicament '{medicament}' (qtt: {qtt}, dispo: {disponibilite}, cat: {category}, loc: {location}) avec un délai de {delay:.2f} secondes.")
                    time.sleep(delay)

        print("Toutes les données ont été insérées avec succès.")

    except (Exception, psycopg2.Error) as error:
        print("Erreur lors de l'insertion dans la table", error)

    finally:
        if connection:
            cursor.close()
            connection.close()
            print("Connexion à PostgreSQL fermée.")

file_path = 'medicaments.csv'

insert_medications_from_csv(file_path)
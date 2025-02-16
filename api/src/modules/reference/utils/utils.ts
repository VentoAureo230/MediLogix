import * as path from 'path';
import { CSVReference } from '../entities/reference.entities';
import { readFile } from 'fs/promises';

export async function extractListFromCSV<T>(filePath: string, fromCsvRow: (row: any) => T): Promise<T[]> {
   const file =  await readFile(path.resolve(filePath), 'utf-8');
   return file.split('\n').filter(row => row.trim() !== '').map(row => fromCsvRow(row.split(';')));   
}

export async function searchReferenceInCSV(filePath: string, cip13: string): Promise<CSVReference | undefined> {
   const allReferences = await extractListFromCSV<CSVReference>(filePath, row => ({name : row[2], cip13 : row[1], cip7 : row[0]}));
   return allReferences.find((ref) => ref.cip13 === cip13);
}
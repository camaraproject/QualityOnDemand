// CAMARA Project - support function for Spectral linter
// 31.01.2024 - initial version

const sensitiveData = ['MSISDN','IMSI','phoneNumber'];

export default async function (input) {

  // Iterate over properties of the input object
  for (const path in input) {

    if (typeof path === 'string') {
      for (const word of sensitiveData ) {
        const regex = new RegExp(`\\b${word}\\b`, 'g');  // Use a regular expression to match 'word' as a standalone word

           if (regex.test(path)) {

              const warningRuleName = 'camara-security-no-secrets-in-path-or-query-parameters';
              const description = `sensitiveData  Data found in path: Consider avoiding the use of sensitiveData  data '${word}'`;
              const location = `paths.${path}`;
              console.log(`warning  ${warningRuleName}  ${description}  ${location}`);

        }
      }
    }
  }
}

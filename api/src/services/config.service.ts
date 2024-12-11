import * as Joi from 'joi';

declare var process: {
  env: EnvConfig;
};

export interface EnvConfig {
  [key: string]: string;
}

export class ConfigService {
  private readonly envConfig: EnvConfig;

  constructor() {
    this.envConfig = this.validateInput(process.env);
  }

  /**
   * Ensures all needed variables are set, and returns the validated JavaScript object
   * including the applied default values.
   */
  private validateInput(envConfig: EnvConfig): EnvConfig {
    const envVarsSchema: Joi.ObjectSchema = Joi.object({
      NODE_ENV: Joi.string()
        .valid('production', 'local', 'test')
        .default('local'),
      CORS_ORIGIN: Joi.string(),
      JWT_PRIVATE_KEY: Joi.string().required(),
      JWT_PUBLIC_KEY: Joi.string().required(),
      JWT_PASSPHRASE: Joi.string(),
      JWT_EXPIRES_IN: Joi.string(),
    }).unknown(true);

    const { error, value: validatedEnvConfig } =
      envVarsSchema.validate(envConfig);
    if (error) {
      throw new Error(`Config validation error: ${error.message}`);
    }
    return validatedEnvConfig;
  }

  get corsOrigin(): string {
    return String(this.envConfig.CORS_ORIGIN);
  }

  get jwtPrivateKey(): string {
    return atob(String(this.envConfig.JWT_PRIVATE_KEY));
  }

  get jwtPublicKey(): string {
    return atob(String(this.envConfig.JWT_PUBLIC_KEY));
  }

  get jwtPassphrase(): string {
    return String(this.envConfig.JWT_PASSPHRASE);
  }

  get jwtExpiresIn(): string {
    return String(this.envConfig.JWT_EXPIRES_IN);
  }
}
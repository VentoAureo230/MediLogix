import { Controller, Get } from '@nestjs/common';
import { ApiOperation, ApiResponse } from '@nestjs/swagger';

@Controller('info')
export class InfoController {

  @Get('')
  @ApiOperation({ summary: 'Show API Version', description: 'Show API Version' })
  @ApiResponse({
    status: 200,
    description: 'API version information',
    schema: {
      example: {
        name: 'Medilogix API',
        version: '1.0.0',
      },
    },
  })
  info() {
    return {
      name: 'Medilogix API',
      // Version is modified by version script, no need to modify anything here.
      version: '1.0.0',
    };
  }
}
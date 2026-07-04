import {
  Body,
  Controller,
  Get,
  Param,
  Patch,
  Post,
  Query,
  UseGuards,
} from '@nestjs/common';
import { ApiBearerAuth, ApiOperation, ApiTags } from '@nestjs/swagger';
import { ReferenceService } from './reference.service';
import { CreateReferenceDto } from './dto/create-reference.dto';
import { UpdateReferenceDto } from './dto/update-reference.dto';
import { AuthGuardService } from 'src/services/auth-guard.service';

@ApiTags('reference')
@ApiBearerAuth()
@UseGuards(AuthGuardService)
@Controller('reference')
export class ReferenceController {
  constructor(private referenceService: ReferenceService) {}

  @Get()
  @ApiOperation({
    summary: 'List references (paginated, optional low-stock filter)',
  })
  async listReferences(
    @Query('page') page?: string,
    @Query('limit') limit?: string,
    @Query('maxQuantity') maxQuantity?: string,
  ) {
    return await this.referenceService.findAll(
      page ? parseInt(page, 10) : undefined,
      limit ? parseInt(limit, 10) : undefined,
      maxQuantity !== undefined ? parseInt(maxQuantity, 10) : undefined,
    );
  }

  @Get(':cip13')
  @ApiOperation({ summary: 'Get reference by cip13' })
  async getReferenceByCip13(@Param('cip13') cip13: string) {
    return await this.referenceService.getByCip13(cip13);
  }

  @Post()
  @ApiOperation({ summary: 'Add a reference' })
  async createReference(@Body() createReferenceDto: CreateReferenceDto) {
    return await this.referenceService.create(createReferenceDto);
  }

  @Patch(':cip13')
  @ApiOperation({ summary: 'Add quantity to a reference' })
  async updataReferenceQuantity(
    @Param('cip13') cip13: string,
    @Body() updateReferenceDto: UpdateReferenceDto,
  ) {
    return await this.referenceService.updateQuantity(
      cip13,
      updateReferenceDto,
    );
  }
}

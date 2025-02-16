import { Body, Controller, Get, Param, Patch, Post } from "@nestjs/common";
import { ApiOperation, ApiTags } from "@nestjs/swagger";
import { ReferenceService } from "./reference.service";
import { CreateReferenceDto } from "./dto/create-reference.dto";
import { UpdateReferenceDto } from "./dto/update-reference.dto";

@ApiTags('reference')
@Controller('reference')
export class ReferenceController {
   constructor(private referenceService: ReferenceService) { }

   @Get(':cip13')
   @ApiOperation({ summary: 'Get reference by cip13' })
   async getReferenceByCip13(@Param('cip13') cip13: string) {
      return await this.referenceService.getByCip13(cip13);
   }

   @Post()
   @ApiOperation({ summary: 'Add a reference'})
   async createReference(@Body() createReferenceDto: CreateReferenceDto) {
      return await this.referenceService.create(createReferenceDto);
   }

   @Patch(':cip13')
   @ApiOperation({ summary: 'Add quantity to a reference'})
   async updataReferenceQuantity(@Param('cip13') cip13: string, @Body() updateReferenceDto: UpdateReferenceDto) {
      return await this.referenceService.updateQuantity(cip13, updateReferenceDto);
   }
}
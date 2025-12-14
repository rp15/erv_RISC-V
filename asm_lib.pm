package asm_lib;




my %ISAhash;

$ISAhash{add}{opcode} = 0x33;
$ISAhash{add}{funct3} = 0x0;
$ISAhash{add}{funct7} = 0x0;
$ISAhash{add}{function} = 'in0 + in1';
$ISAhash{addw}{opcode} = 0x3b;
$ISAhash{addw}{funct3} = 0x0;
$ISAhash{addw}{funct7} = 0x0;
$ISAhash{addw}{function} = "WORD'(in0[31:0] + in1[31:0])";
$ISAhash{addi}{opcode} = 0x13;
$ISAhash{addi}{funct3} = 0x0;
$ISAhash{addi}{funct7} = '-';
$ISAhash{addi}{function} = 'in0 + in1';
$ISAhash{addiw}{opcode} = 0x1b;
$ISAhash{addiw}{funct3} = 0x0;
$ISAhash{addiw}{funct7} = '-';
$ISAhash{addiw}{function} = "WORD'(in0[31:0] + in1[31:0])";
$ISAhash{and}{opcode} = 0x33;
$ISAhash{and}{funct3} = 0x7;
$ISAhash{and}{funct7} = 0x0;
$ISAhash{and}{function} = 'in0 & in1';
$ISAhash{andi}{opcode} = 0x13;
$ISAhash{andi}{funct3} = 0x7;
$ISAhash{andi}{funct7} = '-';
$ISAhash{andi}{function} = 'in0 & in1';
$ISAhash{or}{opcode} = 0x33;
$ISAhash{or}{funct3} = 0x6;
$ISAhash{or}{funct7} = 0x0;
$ISAhash{or}{function} = 'in0 | in1';
$ISAhash{ori}{opcode} = 0x13;
$ISAhash{ori}{funct3} = 0x6;
$ISAhash{ori}{funct7} = '-';
$ISAhash{ori}{function} = 'in0 | in1';
$ISAhash{sll}{opcode} = 0x33;
$ISAhash{sll}{funct3} = 0x1;
$ISAhash{sll}{funct7} = 0x0;
$ISAhash{sll}{function} = 'in0 << in1[5:0]';
$ISAhash{sllw}{opcode} = 0x3b;
$ISAhash{sllw}{funct3} = 0x1;
$ISAhash{sllw}{funct7} = 0x0;
$ISAhash{sllw}{function} = "WORD'(in0[31:0] << in1[4:0])";
$ISAhash{slli}{opcode} = 0x13;
$ISAhash{slli}{funct3} = 0x1;
$ISAhash{slli}{funct7} = 0x0;
$ISAhash{slli}{function} = 'in0 << in1[5:0]';
$ISAhash{slliw}{opcode} = 0x1b;
$ISAhash{slliw}{funct3} = 0x1;
$ISAhash{slliw}{funct7} = 0x0;
$ISAhash{slliw}{function} = "WORD'(in0[31:0] << in1[4:0])";
$ISAhash{slt}{opcode} = 0x33;
$ISAhash{slt}{funct3} = 0x2;
$ISAhash{slt}{funct7} = 0x0;
$ISAhash{slt}{function} = "in0 < in1 ? 64'b1 : 64'b0";
$ISAhash{slti}{opcode} = 0x13;
$ISAhash{slti}{funct3} = 0x2;
$ISAhash{slti}{funct7} = '-';
$ISAhash{slti}{function} = "in0 < in1 ? 64'b1 : 64'b0";
$ISAhash{sltiu}{opcode} = 0x13;
$ISAhash{sltiu}{funct3} = 0x3;
$ISAhash{sltiu}{funct7} = '-';
$ISAhash{sltiu}{function} = "unsigned'(in0) < unsigned'(in1) ? 64'b1 : 64'b0";
$ISAhash{sltu}{opcode} = 0x33;
$ISAhash{sltu}{funct3} = 0x3;
$ISAhash{sltu}{funct7} = 0x0;
$ISAhash{sltu}{function} = "unsigned'(in0) < unsigned'(in1) ? 64'b1 : 64'b0";
$ISAhash{sra}{opcode} = 0x33;
$ISAhash{sra}{funct3} = 0x5;
$ISAhash{sra}{funct7} = 0x20;
$ISAhash{sra}{function} = 'in0 >>> in1[5:0]';
$ISAhash{sraw}{opcode} = 0x3b;
$ISAhash{sraw}{funct3} = 0x5;
$ISAhash{sraw}{funct7} = 0x20;
$ISAhash{sraw}{function} = "WORD'(in0[31:0] >>> in1[4:0])";
$ISAhash{srai}{opcode} = 0x13;
$ISAhash{srai}{funct3} = 0x5;
$ISAhash{srai}{funct7} = 0x20;
$ISAhash{srai}{function} = 'in0 >>> in1[5:0]';
$ISAhash{sraiw}{opcode} = 0x1b;
$ISAhash{sraiw}{funct3} = 0x5;
$ISAhash{sraiw}{funct7} = 0x20;
$ISAhash{sraiw}{function} = "WORD'(in0[31:0] >>> in1[4:0])";
$ISAhash{srl}{opcode} = 0x33;
$ISAhash{srl}{funct3} = 0x5;
$ISAhash{srl}{funct7} = 0x0;
$ISAhash{srl}{function} = 'in0 >> in1[5:0]';
$ISAhash{srlw}{opcode} = 0x3b;
$ISAhash{srlw}{funct3} = 0x5;
$ISAhash{srlw}{funct7} = 0x0;
$ISAhash{srlw}{function} = "WORD'(in0[31:0] >> in1[4:0])";
$ISAhash{srli}{opcode} = 0x13;
$ISAhash{srli}{funct3} = 0x5;
$ISAhash{srli}{funct7} = 0x0;
$ISAhash{srli}{function} = 'in0 >> in1[5:0]';
$ISAhash{srliw}{opcode} = 0x1b;
$ISAhash{srliw}{funct3} = 0x5;
$ISAhash{srliw}{funct7} = 0x0;
$ISAhash{srliw}{function} = "WORD'(in0[31:0] >> in1[4:0])";
$ISAhash{sub}{opcode} = 0x33;
$ISAhash{sub}{funct3} = 0x0;
$ISAhash{sub}{funct7} = 0x20;
$ISAhash{sub}{function} = 'in0 - in1';
$ISAhash{subw}{opcode} = 0x3b;
$ISAhash{subw}{funct3} = 0x0;
$ISAhash{subw}{funct7} = 0x20;
$ISAhash{subw}{function} = "WORD'(in0[31:0] - in1[31:0])";
$ISAhash{xor}{opcode} = 0x33;
$ISAhash{xor}{funct3} = 0x4;
$ISAhash{xor}{funct7} = 0x0;
$ISAhash{xor}{function} = 'in0 ^ in1';
$ISAhash{xori}{opcode} = 0x13;
$ISAhash{xori}{funct3} = 0x4;
$ISAhash{xori}{funct7} = '-';
$ISAhash{xori}{function} = 'in0 ^ in1';
$ISAhash{mul}{opcode} = 0x33;
$ISAhash{mul}{funct3} = 0x0;
$ISAhash{mul}{funct7} = 0x1;
$ISAhash{mul}{function} = 'in0 * in1';
$ISAhash{mulw}{opcode} = 0x3b;
$ISAhash{mulw}{funct3} = 0x0;
$ISAhash{mulw}{funct7} = 0x1;
$ISAhash{mulw}{function} = "WORD'(in0[31:0] * in1[31:0])";
$ISAhash{mulh}{opcode} = 0x33;
$ISAhash{mulh}{funct3} = 0x1;
$ISAhash{mulh}{funct7} = 0x1;
$ISAhash{mulh}{function} = "upper_dword(in0 * in1)";
$ISAhash{mulhsu}{opcode} = 0x33;
$ISAhash{mulhsu}{funct3} = 0x2;
$ISAhash{mulhsu}{funct7} = 0x1;
$ISAhash{mulhsu}{function} = "upper_dword(in0 * unsigned'(in1))";
$ISAhash{mulhu}{opcode} = 0x33;
$ISAhash{mulhu}{funct3} = 0x3;
$ISAhash{mulhu}{funct7} = 0x1;
$ISAhash{mulhu}{function} = "upper_dword(unsigned'(in0) * unsigned'(in1))";
$ISAhash{div}{opcode} = 0x33;
$ISAhash{div}{funct3} = 0x4;
$ISAhash{div}{funct7} = 0x1;
$ISAhash{div}{function} = 'in0 / in1';
$ISAhash{divw}{opcode} = 0x3b;
$ISAhash{divw}{funct3} = 0x4;
$ISAhash{divw}{funct7} = 0x1;
$ISAhash{divw}{function} = "WORD'(in0[31:0] / in1[31:0])";
$ISAhash{divu}{opcode} = 0x33;
$ISAhash{divu}{funct3} = 0x5;
$ISAhash{divu}{funct7} = 0x1;
$ISAhash{divu}{function} = "unsigned'(in0) / unsigned'(in1)";
$ISAhash{divuw}{opcode} = 0x3b;
$ISAhash{divuw}{funct3} = 0x5;
$ISAhash{divuw}{funct7} = 0x1;
$ISAhash{divuw}{function} = "WORD'(unsigned'(in0[31:0]) / unsigned'(in1[31:0]))";
$ISAhash{rem}{opcode} = 0x33;
$ISAhash{rem}{funct3} = 0x6;
$ISAhash{rem}{funct7} = 0x1;
$ISAhash{rem}{function} = 'in0 % in1';
$ISAhash{remw}{opcode} = 0x3b;
$ISAhash{remw}{funct3} = 0x6;
$ISAhash{remw}{funct7} = 0x1;
$ISAhash{remw}{function} = "WORD'(in0[31:0] % in1[31:0])";
$ISAhash{remu}{opcode} = 0x33;
$ISAhash{remu}{funct3} = 0x7;
$ISAhash{remu}{funct7} = 0x1;
$ISAhash{remu}{function} = "unsigned'(in0) % unsigned'(in1)";
$ISAhash{remuw}{opcode} = 0x3b;
$ISAhash{remuw}{funct3} = 0x7;
$ISAhash{remuw}{funct7} = 0x1;
$ISAhash{remuw}{function} = "WORD'(unsigned'(in0[31:0]) % unsigned'(in1[31:0]))";

$ISAhash{lui}{opcode} = 0x37;
$ISAhash{auipc}{opcode} = 0x17;

$ISAhash{jal}{opcode} = 0x6f;

$ISAhash{sb}{opcode} = 0x23;
$ISAhash{sb}{funct3} = 0x0;
$ISAhash{sh}{opcode} = 0x23;
$ISAhash{sh}{funct3} = 0x1;
$ISAhash{sw}{opcode} = 0x23;
$ISAhash{sw}{funct3} = 0x2;
$ISAhash{sd}{opcode} = 0x23;
$ISAhash{sd}{funct3} = 0x3;

$ISAhash{lb}{opcode} = 0x3;
$ISAhash{lb}{funct3} = 0x0;
$ISAhash{lh}{opcode} = 0x3;
$ISAhash{lh}{funct3} = 0x1;
$ISAhash{lw}{opcode} = 0x3;
$ISAhash{lw}{funct3} = 0x2;
$ISAhash{ld}{opcode} = 0x3;
$ISAhash{ld}{funct3} = 0x3;

$ISAhash{jalr}{opcode} = 0x67;
$ISAhash{jalr}{funct3} = 0x0;

$ISAhash{beq}{opcode} = 0x63;
$ISAhash{beq}{funct3} = 0x0;
$ISAhash{bne}{opcode} = 0x63;
$ISAhash{bne}{funct3} = 0x1;
$ISAhash{blt}{opcode} = 0x63;
$ISAhash{blt}{funct3} = 0x4;
$ISAhash{bge}{opcode} = 0x63;
$ISAhash{bge}{funct3} = 0x5;
$ISAhash{bltu}{opcode} = 0x63;
$ISAhash{bltu}{funct3} = 0x6;
$ISAhash{bgeu}{opcode} = 0x63;
$ISAhash{bgeu}{funct3} = 0x7;


#my @sb_type = qw(beq bne blt bge bltu bgeu);



sub getInstInfo
{
  return $ISAhash{shift(@_)}{shift(@_)};
}


sub test
{
  print("\n\nPackage test.\n\n\n");
}

sub create_symbol_table
{}

sub assemble_data_seg
{}

sub assemble_text_seg
{}

########### KEV ##############


sub pseudo2simple
{
  my @convertedInstr;
  my $pseudo = shift;
  my @instr;
  my @instr1;

  if ($pseudo =~ m/^\h*jr /){
        @instr = split /\h/, $pseudo;
        @instr1 = split /,/, $instr[1];
        my $size = @instr1;
        if ($size==1){
        @convertedInstr = ("jalr x0,$instr[1],0");
        return @convertedInstr;}
        return ($pseudo);
        }


  if ($pseudo =~ m/^\h*j\h/){
        @instr = split /\h/, $pseudo;
        @instr1 = split /,/, $instr[1];
        my $size = @instr1;
        if ($size==1){
        @convertedInstr = ("jal x0,$instr[1]");
        return @convertedInstr;}
        return ($pseudo);
        }

  if ($pseudo =~ m/^\h*jal\h/){
        @instr = split /\h/, $pseudo;
        @instr1 = split /,/, $instr[1];
        my $size = @instr1;
        if ($size==1){
        @convertedInstr = ("jal x1,$instr[1]");
        return @convertedInstr;}
        return ($pseudo);
        }


  if ($pseudo =~ m/^\h*jalr /){
        @instr = split /\h/, $pseudo;
        @instr1 = split /,/, $instr[1];
        my $size = @instr1;
        if ($size==1){
        @convertedInstr = ("jalr x1,$instr[1],0" );
        return @convertedInstr;}
        return ($pseudo);
        }

  if ($pseudo =~ m/^\h*call /){
        @instr = split /\h/, $pseudo;
        @instr1 = split /,/, $instr[1];
        my $size = @instr1;
        if ($size==1){
        @convertedInstr = ("lui x6,%hi($instr[1])" , "jalr x1,x6,%lo($instr[1])");
        return @convertedInstr;}
        return ($pseudo);
        }

  if ($pseudo =~ m/^\h*tail /){
        @instr = split /\h/, $pseudo;
        @instr1 = split /,/, $instr[1];
        my $size = @instr1;
        if ($size==1){
        @convertedInstr = ("lui x6,%hi($instr[1])" , "jalr x1,x6,%lo($instr[1])");
        return @convertedInstr;}
        return ($pseudo);
        }

  if ($pseudo =~ m/^\h*ret /){

        @convertedInstr = ("jalr x0,x1,0");
        return @convertedInstr;
        }

if ($pseudo =~ m/^\h*beqz /){
        @instr = split /\h/, $pseudo;
        @instr1 = split /,/, $instr[1];
        my $size = @instr1;
        if ($size==2){
        @convertedInstr = ("beq $instr1[0],x0,$instr1[1]");
        return @convertedInstr;}
        return ($pseudo);
        }


  if ($pseudo =~ m/^\h*bnez /){
        @instr = split /\h/, $pseudo;
        @instr1 = split /,/, $instr[1];
        my $size = @instr1;
        if ($size==2){
        @convertedInstr = ("bne $instr1[0],x0,$instr1[1]");
        return @convertedInstr;}
        return ($pseudo);
        }

  if ($pseudo =~ m/^\h*blez /){
        @instr = split /\h/, $pseudo;
        @instr1 = split /,/, $instr[1];
        my $size = @instr1;
        if ($size==2){
        @convertedInstr = ("bge x0,$instr1[0],$instr1[1]");
        return @convertedInstr;}
        return ($pseudo);
        }

  if ($pseudo =~ m/^\h*bgez /){
        @instr = split /\h/, $pseudo;
        @instr1 = split /,/, $instr[1];
        my $size = @instr1;
        if ($size==2){
        @convertedInstr = ("bge $instr1[0],x0,$instr1[1]");
        return @convertedInstr;}
        return ($pseudo);
        }

  if ($pseudo =~ m/^\h*bltz /){
        @instr = split /\h/, $pseudo;
        @instr1 = split /,/, $instr[1];
        my $size = @instr1;
        if ($size==2){
        @convertedInstr = ("blt $instr1[0],x0,$instr1[1]");
        return @convertedInstr;}
        return ($pseudo);
        }



  if ($pseudo =~ m/^\h*bgtz /){
        @instr = split /\h/, $pseudo;
        @instr1 = split /,/, $instr[1];
        my $size = @instr1;
        if ($size==2){
        @convertedInstr = ("blt x0,$instr1[0],$instr1[1]");
        return @convertedInstr;}
        return ($pseudo);
        }


  if ($pseudo =~ m/^\h*fence /){
        @instr = split /\h/, $pseudo;
        my $size = @instr;
        if ($size==1){
        @convertedInstr = ("fence iorw,iorw");
        return @convertedInstr;}
        return ($pseudo);
        }

if ($pseudo =~ m/^\h*bleu /){
        @instr = split /\h/, $pseudo;
        @instr1 = split /,/, $instr[1];
        my $size = @instr1;
        if ($size==3){
        @convertedInstr = ("bgeu $instr1[1],$instr1[0],$instr1[2]");
        return @convertedInstr;}
        return ($pseudo);
        }



  if ($pseudo =~ m/^\h*bgtu /){
        @instr = split /\h/, $pseudo;
        @instr1 = split /,/, $instr[1];
        my $size = @instr1;
        if ($size==3){
        @convertedInstr = ("bltu $instr1[1],$instr1[0],$instr1[2]");
        return @convertedInstr;}
        return ($pseudo);
        }

  if ($pseudo =~ m/^\h*ble /){
        @instr = split /\h/, $pseudo;
        @instr1 = split /,/, $instr[1];
        my $size = @instr1;
        if ($size==3){
        @convertedInstr = ("bge $instr1[1],$instr1[0],$instr1[2]");
        return @convertedInstr;}
        return ($pseudo);
        }

  if ($pseudo =~ m/^\h*bgt /){
        @instr = split /\h/, $pseudo;
        @instr1 = split /,/, $instr[1];
        my $size = @instr1;
        if ($size==3){
        @convertedInstr = ("blt $instr1[1],$instr1[0],$instr1[2]");
        return @convertedInstr;}
        return ($pseudo);
        }


  if ($pseudo =~ m/^\h*sgtz /){
        @instr = split /\h/, $pseudo;
        @instr1 = split /,/, $instr[1];
        my $size = @instr1;
        if ($size==2){
        @convertedInstr = ("slt $instr1[0],x0,$instr1[1]");
        return @convertedInstr;}
        return ($pseudo);
        }

  if ($pseudo =~ m/^\h*sltz /){
        @instr = split /\h/, $pseudo;
        @instr1 = split /,/, $instr[1];
        my $size = @instr1;
        if ($size==2){
        @convertedInstr = ("slt $instr1[0],$instr1[1],x0");
        return @convertedInstr;}
        return ($pseudo);
        }

  if ($pseudo =~ m/^\h*snez /){
        @instr = split /\h/, $pseudo;
        @instr1 = split /,/, $instr[1];
        my $size = @instr1;
        if ($size==2){
        @convertedInstr = ("sltu $instr1[0],x0,$instr1[1]");
        return @convertedInstr;}
        return ($pseudo);
        }

if ($pseudo =~ m/^\h*seqz /){
        @instr = split /\h/, $pseudo;
        @instr1 = split /,/, $instr[1];
        my $size = @instr1;
        if ($size==2){
        @convertedInstr = ("sltiu $instr1[0],$instr1[1],1");
        return @convertedInstr;}
        return ($pseudo);
        }

  if ($pseudo =~ m/^\h*sext.w /){
        @instr = split /\h/, $pseudo;
        @instr1 = split /,/, $instr[1];
        my $size = @instr1;
        if ($size==2){
        @convertedInstr = ("addiw $instr1[0],$instr1[1],0");
        return @convertedInstr;}
        return ($pseudo);
        }

  if ($pseudo =~ m/^\h*negw /){
        @instr = split /\h/, $pseudo;
        @instr1 = split /,/, $instr[1];
        my $size = @instr1;
        if ($size==2){
        @convertedInstr = ("subw $instr1[0],x0,$instr1[1]");
        return @convertedInstr;}
        return ($pseudo);
        }


  if ($pseudo =~ m/^\h*neg /){
        @instr = split /\h/, $pseudo;
        @instr1 = split /,/, $instr[1];
        my $size = @instr1;
        if ($size==2){
        @convertedInstr = ("sub $instr1[0],x0,$instr1[1]");
        return @convertedInstr;}
        return ($pseudo);
        }


  if ($pseudo =~ m/^\h*not /){
        @instr = split /\h/, $pseudo;
        @instr1 = split /,/, $instr[1];
        my $size = @instr1;
        if ($size==2){
        @convertedInstr = ("xori $instr1[0],$instr1[1],-1");
        return @convertedInstr;}
        return ($pseudo);
        }


  if ($pseudo =~ m/^\h*mv /){
        @instr = split /\h/, $pseudo;
        #print "Inst:_$pseudo ___";
        @instr1 = split /,/, $instr[1];
        #print "Args:_$instr1[0] ___\n";

        my $size = @instr1;
        if ($size==2){
        @convertedInstr = ("addi $instr1[0],$instr1[1],0");
        return @convertedInstr;}
        return ($pseudo);
        }

  if ($pseudo =~ m/^\h*nop/){
        @instr = split /\h/, $pseudo;
        my $size = @instr;
        if ($size==1){
        @convertedInstr = ("addi x0,x0,0");
        return @convertedInstr;}
        return ($pseudo);
        }

if ($pseudo =~ m/^\h*la /){
        @instr = split /\h/, $pseudo;
        @instr1 = split /,/, $instr[1];
        my $size = @instr1;
        if ($size==2){
        @convertedInstr = ("lui $instr1[0],%hi($instr1[1])" , "addi $instr1[0],$instr1[0],%lo($instr1[1])");
        return @convertedInstr;}
        return ($pseudo);
        }


#@pseudo = qw(lb lh lw ld sb sh sw sd  ); INSTRUCTION LEFT!!!!!!!! FORMAT DOUBT AND li INSTRUCTION FORMAT UNKNOWN (MYRIAD)

if ($pseudo =~ m/^\h*li/){
       @instr = split /\h/, $pseudo;
       @instr1 = split /,/, $instr[1];
       my $size = @instr1;
       if ($size==2){

       @convertedInstr = ("lui $instr1[0]," . ($instr1[1] >> 12) , "addi $instr1[0],$instr1[0]," . ($instr1[1] & 0xfff));

       return @convertedInstr;}
       return ($pseudo);
                                                                }




}


##########################

sub FUNC
{
  my $inst = shift(@_);

  

  my @ret;

  push @ret, $inst;

  return @ret;
}

sub replace_registers
{
  my $inst = shift(@_);

  # Replace register names with actual register numbers.
  # Between spaces, between comma and space, between space and comma, between commas, between parentheses, between spaces and end of line, between comma and end of line.
  for (my $reg = 0; $reg < 32; $reg++)
  {
    $inst =~ s/\hx$reg\h/ $reg /g;
    $inst =~ s/,x$reg\h/,$reg /g;
    $inst =~ s/\hx$reg,/ $reg,/g;
    $inst =~ s/,x$reg,/,$reg,/g;
    $inst =~ s/\(x$reg\)/\($reg\)/g;
    $inst =~ s/\hx$reg$/ $reg/g;
    $inst =~ s/,x$reg$/,$reg/g;
  }

  
  my $i = 0;

  for (qw(zero ra sp gp tp))
  {
    $inst =~ s/\h$_\h/ $i /g;
    $inst =~ s/,$_\h/,$i /g;
    $inst =~ s/\h$_,/ $i,/g;
    $inst =~ s/,$_,/,$i,/g;
    $inst =~ s/\($_\)/\($i\)/g;
    $inst =~ s/\h$_$/ $i/g;
    $inst =~ s/,x$_$/,$i/g;

    $i++;
  }

  $inst =~ s/\hfp\h/ 8 /g;
  $inst =~ s/,fp\h/,8 /g;
  $inst =~ s/\hfp,/ 8,/g;
  $inst =~ s/,fp,/,8,/g;
  $inst =~ s/\(fp\)/\(8\)/g;
  $inst =~ s/\hfp$/ 8/g;
  $inst =~ s/,fp$/,8/g;

  for (my $reg = 0; $reg < 3; $reg++)
  {
    $i = $reg + 5;

    $inst =~ s/\ht$reg\h/ $i/g;
    $inst =~ s/,t$reg\h/,$i/g;
    $inst =~ s/\ht$reg,/ $i,/g;
    $inst =~ s/,t$reg,/,$i,/g;
    $inst =~ s/\(t$reg\)/\($i\)/g;
    $inst =~ s/\ht$reg$/ $i/g;
    $inst =~ s/,t$reg$/,$i/g;
  }

  for (my $reg = 3; $reg < 7; $reg++)
  {
    $i = $reg + 25;

    $inst =~ s/\ht$reg\h/ $i /g;
    $inst =~ s/,t$reg\h/,$i /g;
    $inst =~ s/\ht$reg,/ $i,/g;
    $inst =~ s/,t$reg,/,$i,/g;
    $inst =~ s/\(t$reg\)/\($i\)/g;
    $inst =~ s/\ht$reg$/ $i/g;
    $inst =~ s/,t$reg$/,$i/g;    
  }

  $inst =~ s/\hs0\h/ 8 /g;
  $inst =~ s/,s0\h/,8 /g;
  $inst =~ s/\hs0,/ 8,/g;
  $inst =~ s/,s0,/,8,/g;
  $inst =~ s/\(s0\)/\(8\)/g;
  $inst =~ s/\hs0$/ 8/g;
  $inst =~ s/,s0$/,8/g;

  $inst =~ s/\hs1\h/ 9 /g;
  $inst =~ s/,s1\h/,9 /g;
  $inst =~ s/\hs1,/ 9,/g;
  $inst =~ s/,s1,/,9,/g;
  $inst =~ s/\(s1\)/\(9\)/g;
  $inst =~ s/\hs1$/ 9/g;
  $inst =~ s/,s1$/,9/g;

  for (my $reg = 2; $reg < 12; $reg++)
  {
    $i = $reg + 16;

    $inst =~ s/\hs$reg\h/ $i /g;
    $inst =~ s/,s$reg\h/,$i /g;
    $inst =~ s/\hs$reg,/ $i,/g;
    $inst =~ s/,s$reg,/,$i,/g;
    $inst =~ s/\(s$reg\)/\($i\)/g;
    $inst =~ s/\hs$reg$/ $i/g;
    $inst =~ s/,s$reg$/,$i/g;
  }

  for (my $reg = 0; $reg < 8; $reg++)
  {
    $i = $reg + 10;

    $inst =~ s/\ha$reg\h/ $i /g;
    $inst =~ s/,a$reg\h/,$i /g;
    $inst =~ s/\ha$reg,/ $i,/g;
    $inst =~ s/,a$reg,/,$i,/g;
    $inst =~ s/\(a$reg\)/\($i\)/g;
    $inst =~ s/\ha$reg$/ $i/g;
    $inst =~ s/,a$reg$/,$i/g;
  }

  return $inst;
}

1;


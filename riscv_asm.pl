#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;

use asm_lib;

asm_lib::test();

my @pseudo = qw(la lb lh lw sb sh sw nop li mv not neg negw sext.w seqz snez sltz sgtz beqz bnez blez bgez bltz bgtz bgt ble bgtu bleu j jal jr jalr ret call tail fence); # LD SD removed.

my @u_type  = qw(lui auipc);
my @uj_type = qw(jal);
my @sb_type = qw(beq bne blt bge bltu bgeu);
my @i_type  = qw(addi addiw slti sltiu xori ori andi slli srli srai slliw srliw sraiw jalr lb lh lw lbu lhu lwu ld);
my @s_type  = qw(sd sb sh sw);
my @r_type  = qw(add addw sub subw sll sllw slt sltu xor srl srlw sra sraw or and mul mulw mulh mulhsu mulhu div divw divu divuw rem remw remu remuw);





my $filename = $ARGV[0];
open(my $fh, '<:encoding(UTF-8)', $filename)
  or die "Could not open file '$filename' $!";

my @lines = <$fh>;

close $fh;

my $original_inst_cnt = 0;
my $decoded_inst_cnt  = 0;

my @inst;

for (@lines)
{
  chomp $lines[$original_inst_cnt];
 
  if ($lines[$original_inst_cnt] =~ /^\h+(\S+)/) # Instruction.
  {
    if (scalar grep { $1 eq $_ } @pseudo) # Pseudo instruction.
    {
      #for # Generate the actual number of real instructions.
      #{
      #  
      #}

# TODO TODO
      $lines[$original_inst_cnt] =~ s/^\h+//; # Remove the leading spaces.
      $lines[$original_inst_cnt] =~ s/\h+/ /; # Only leave a single space between the instruction and its arguments.

      #print "$lines[$original_inst_cnt]\n";

      #$lines[$original_inst_cnt] = "   " . $lines[$original_inst_cnt]; # Add back some leading spaces. TODO TODO

      my @real_insts = asm_lib::pseudo2simple($lines[$original_inst_cnt]);

      for (@real_insts)
      {
        $_ = "   " . $_;
      }
      
      push @inst, @real_insts;


      $decoded_inst_cnt += scalar @real_insts;
      $original_inst_cnt++;
    }
    elsif ($lines[$original_inst_cnt] =~ /^\h+(add|slt|xor|or|and|sll|srl|sra)w*u*\h+\w+,\w+,-?\d+/) # It might need to be an 'addi.'
    {
      #        add     sp,sp,-48
      #print $lines[$original_inst_cnt] . "\n\n\n\nXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX\nXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX\nXXXXXXXXXXXX\n\n";

      #$lines[$original_inst_cnt] =~ s/add/addi/;
      my $replacer = $1 . 'i';

      $lines[$original_inst_cnt] =~ s/$1/$replacer/;

      #print $lines[$original_inst_cnt] . "\n\n\n\nXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX\nXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX\nXXXXXXXXXXXX\n\n";

      push @inst, $lines[$original_inst_cnt];
      $decoded_inst_cnt++;
      $original_inst_cnt++;
    }
    else # Real instruction.
    {
      push @inst, $lines[$original_inst_cnt];
      $decoded_inst_cnt++;
      $original_inst_cnt++;
    }
  }
  else # Something else.
  {
    push @inst, $lines[$original_inst_cnt];
    $decoded_inst_cnt++;
    $original_inst_cnt++;
  }
}

$original_inst_cnt = 0;

# Reorganize code by moving all functions AND LABELS after main. (main is where the code starts executing so it should be located at 0x00400000 followed by everything else.)
# This assumes that every function is compiled to before main and labels after main are part of main. Have to be tested. TODO
# Throw away useless info.

my %constants_table;
my @organized_inst_list;

for (my $idx = 0; $idx < scalar @inst; $idx++)
{
  my ($cnst_lbl);
  my ($cnst_val);

  if ((($cnst_lbl) = $inst[$idx] =~ /^(\S+):/) && (($cnst_val) = $inst[$idx + 1] =~ /^\s+\.dword\s+(-?\d+)/)) # 64b (the only allowed) constant.
  {
    $constants_table{$cnst_lbl} = $cnst_val;
  }
  elsif ((($cnst_lbl) = $inst[$idx] =~ /^(\S+):/) && (($cnst_val) = $inst[$idx + 1] =~ /^\s+\.zero\s+(-?\d+)/)) # 64b (the only allowed) constant.
  {
    $constants_table{$cnst_lbl} = 0;
  }
  elsif ($inst[$idx] =~ /^main:/)
  {
    my @temp_array;

    push @temp_array, $inst[$idx];

    $idx++;

    push @temp_array, "addi 0,0,0"; # Add two nops to mitigate possible reset issues.
    push @temp_array, "addi 0,0,0";
    # Don't increment $idx since it's indexing the original list, not this new one.

    for (; $inst[$idx] !~ /^\s+\.size/; $idx++)
    {
      push @temp_array, $inst[$idx];
    }

    $temp_array[-1] = "EBREAK"; # Replace last jalr with terminating pseudo instruction. Used in testbench to stop running the code.
    # Don't increment $idx since it's indexing the original list, not this new one.

    unshift @organized_inst_list, @temp_array;
  }
  elsif ($inst[$idx] =~ /^(\S+):/ || $inst[$idx] =~ /^\s+\w+/)
  {
    push @organized_inst_list, $inst[$idx];
  }
}

#print Dumper(\@organized_inst_list);
#print Dumper(\%constants_table);

# Make the symbol table.


# Replace the registers by the numbers instead of names.
for (@organized_inst_list)
{
  $_ = asm_lib::replace_registers($_);
  #print $_ . "\n";
}



# Create imem, dmem, symbol table.
my %symbol_table;
my %inst_mem;
my %data_mem;

my $inst_addr = 0x00400000;

for (@organized_inst_list)
{
  if ($_ =~ /^(\S+):/)
  {
    $symbol_table{$1} = $inst_addr;
  }
  else
  {
    $inst_mem{$inst_addr} = $_;
    $inst_addr += 4;
  }
}


my $data_addr = 0x10000000;

for (keys %constants_table)
{
  $data_mem{$data_addr} = $constants_table{$_};
  $symbol_table{$_} = $data_addr;
  $data_addr += 8;
}


#print Dumper(\%symbol_table);
#print Dumper(\%inst_mem);
#print Dumper(\%data_mem);

# Fix the 64-bit loads, e.g.: "lui a5,%hi(.LC3)" and "ld a4,%lo(.LC3)(a5)" combo.
for (keys %inst_mem)
{
  if ( $inst_mem{$_} =~ m/%(hi|lo)\(([^)]+)\)/ ) # Match and capture everything in the first set of parentheses after %hi or %lo.
  {
    #print "Inst addr: $_ Inst: $inst_mem{$_} HI/LO: $1 Label: $2\n";

    my $hi20 = $symbol_table{$2} >> 12;   #print "HI20: $hi20\n";
    my $lo12 = $symbol_table{$2} & 0xfff; #print "LO12: $lo12\n";

    if ("hi" eq $1)
    {
      $inst_mem{$_} =~ s/%hi\($2\)/$hi20/;
    }
    else
    {
      $inst_mem{$_} =~ s/%lo\($2\)/$lo12/;
    }

    #print "Replaced inst: $inst_mem{$_}\n\n\n\n\n";
  }
}

#print Dumper(\%inst_mem);
foreach my $addr (sort { $a <=> $b } keys %inst_mem)
{
  $inst_mem{$addr} =~ s/^\h+//; # Remove the leading spaces.

  #printf "%x__%s\n", $addr, $inst_mem{$addr};
}


foreach my $addr (sort { $a <=> $b } keys %data_mem)
{
  $data_mem{$addr} =~ s/^\h+//; # Remove the leading spaces.

  #printf "%x__%x\n", $addr, $data_mem{$addr};
}

print "Symbol table:\n\n";

foreach my $addr (sort { $a cmp $b } keys %symbol_table)
{
  $symbol_table{$addr} =~ s/^\h+//; # Remove the leading spaces.

  printf "%s__%08x\n", $addr, $symbol_table{$addr};
}

#print Dumper(\%symbol_table);
#print Dumper(\%data_mem);


my %inst_mem_hex;

foreach my $addr (sort { $a <=> $b } keys %inst_mem)
{
  #print "$addr $inst_mem{addr}\n";

  if ($inst_mem{$addr} =~ m/^(\S+)\h+([^,]+),([^,]+)$/)
  {
    my $instruction = $1;
    my $param1 = $2;
    my $param2 = $3;

    # TODO Check if stuff is always positive in summations (mainly the bitwise and results).

    if (scalar grep { $instruction eq $_ } @u_type) # U type.
    {
      $inst_mem_hex{$addr} = (($param2 =~ m/\.|[a-z]|[A-Z]/ ? $symbol_table{$param2} : $param2) << 12) + ($param1 << 7) + asm_lib::getInstInfo($instruction, "opcode");

      #print "$addr $inst_mem{$addr} $inst_mem_hex{$addr} u_type\n";
    }
    elsif (scalar grep { $instruction eq $_ } @uj_type) # UJ type.
    {
      $inst_mem_hex{$addr} = (((($param2 =~ m/\.|[a-z]|[A-Z]/ ? $symbol_table{$param2} : $param2) - $addr) & 0x0100000) << 11) + # Fetch label address from symbol table (if needed). # >> 20 << 31
                             (((($param2 =~ m/\.|[a-z]|[A-Z]/ ? $symbol_table{$param2} : $param2) - $addr) &    0x07fe) << 20) + # >>  1 << 21
                             (((($param2 =~ m/\.|[a-z]|[A-Z]/ ? $symbol_table{$param2} : $param2) - $addr) &    0x0800) <<  9) + # >> 11 << 20
                             (((($param2 =~ m/\.|[a-z]|[A-Z]/ ? $symbol_table{$param2} : $param2) - $addr) &  0x0ff000) <<  0) + # >> 12 << 12
                             ($param1 << 7) +
                             asm_lib::getInstInfo($instruction, "opcode");

      #print "$addr $inst_mem{$addr} $inst_mem_hex{$addr} uj_type\n";
    }
    elsif (scalar grep { $instruction eq $_ } @s_type) # S type: has three params, but only one comma.
    {
      $param2 =~ m/(-?\d+)\((\d+)\)/;
      my $imm = $1;
      my $rs1 = $2;

      $inst_mem_hex{$addr} = (($imm & 0x0fe0) << 20) + #  >>  5 << 25
                             ($param1         << 20) +
                             ($rs1            << 15) +
                             (asm_lib::getInstInfo($instruction, "funct3") << 12) +
                             (($imm &  0x01f) <<  7) +
                             asm_lib::getInstInfo($instruction, "opcode");

      #print "$addr $inst_mem{$addr} $inst_mem_hex{$addr} s_type\n";
    }
    elsif (scalar grep { $instruction eq $_ } @i_type) # I type: loads have three params, but only one comma.
    {
      $param2 =~ m/(-?\d+)\((\d+)\)/;
      my $imm = $1;
      my $rs1 = $2;

      $inst_mem_hex{$addr} = (($imm & 0x0fff) << 20) +
                             ($rs1            << 15) +
                             (asm_lib::getInstInfo($instruction, "funct3") << 12) +
                             ($param1         <<  7) +
                             asm_lib::getInstInfo($instruction, "opcode");

      #print "$addr $inst_mem{$addr} $inst_mem_hex{$addr} i_type load\n";
    }
    else
    {
      die "Two operands FAIL :: $addr $inst_mem{$addr}\n"
    }
  }
  elsif ($inst_mem{$addr} =~ m/^(\S+)\h+([^,]+),([^,]+),([^,]+)/)
  {
    my $instruction = $1;
    my $param1 = $2;
    my $param2 = $3;
    my $param3 = $4;

    $param3 = ($param3 =~ m/\.|[a-z]|[A-Z]/) ? $symbol_table{$param3} : $param3; # Fetch label address from symbol table (if needed).

    if (scalar grep { $instruction eq $_ } @r_type) # R type.
    {
      $inst_mem_hex{$addr} = (asm_lib::getInstInfo($instruction, "funct7") << 25) + ($param3 << 20) + ($param2 << 15) + (asm_lib::getInstInfo($instruction, "funct3") << 12) + ($param1 << 7) + asm_lib::getInstInfo($instruction, "opcode");

      #print "$addr $inst_mem{$addr} $inst_mem_hex{$addr} r_type\n";
    }
    elsif (scalar grep { $instruction eq $_ } @i_type) # I type.
    {
      $inst_mem_hex{$addr} = (($param3 & 0x0fff) << 20) +
                             ($param2            << 15) +
                             (asm_lib::getInstInfo($instruction, "funct3") << 12) +
                             ($param1         <<  7) +
                             asm_lib::getInstInfo($instruction, "opcode");

      #print "$addr $instruction $inst_mem{$addr} $inst_mem_hex{$addr} i_type not load\n";
    }
    elsif (scalar grep { $instruction eq $_ } @sb_type) # SB type.
    {
      $inst_mem_hex{$addr} = ((($param3 - $addr) & 0x01000) << 19) + # >> 12 << 31
                             ((($param3 - $addr) &  0x07e0) << 20) + # >>  5 << 25
                             ($param2             << 20) +
                             ($param1             << 15) +
                             (asm_lib::getInstInfo($instruction, "funct3") << 12) +
                             ((($param3 - $addr) &   0x01e) <<  7) + # >>  1 <<  8
                             ((($param3 - $addr) &  0x0800) >>  4) + # >> 11 <<  7
                             asm_lib::getInstInfo($instruction, "opcode");

      #print "$addr $inst_mem{$addr} $inst_mem_hex{$addr} sb_type\n";
    }
    else
    {
      die "Three operands FAIL :: $addr $inst_mem{$addr}\n"
    }
  }
  elsif ($inst_mem{$addr} =~ m/^EBREAK$/)
  {
    $inst_mem_hex{$addr} = 0x00100073;
  }
  else
  {
    die "Not two or three operands FAIL :: $addr $inst_mem{$addr}\n"
  }
}


print "\nINSTRUCTION MEMORY:\n\n";

for my $addr (sort { $a <=> $b } keys %inst_mem_hex)
{
  printf "%08x:%08x\n", $addr, 0x0ffffffff & $inst_mem_hex{$addr};
}


print "\nDATA MEMORY:\n\n";

for my $addr (sort { $a <=> $b } keys %data_mem)
{
  $data_mem{$addr} =~ s/^\h+//; # Remove the leading spaces.

  printf "%08x:%016x\n", $addr, $data_mem{$addr};
}





# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::Preferences::CustomerProfile;

use strict;
use warnings;

use Kernel::Language qw(Translatable);

our $ObjectManagerDisabled = 1;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    for my $Needed (qw(UserID UserObject ConfigItem)) {
        die "Got no $Needed!" if !$Self->{$Needed};
    }

    return $Self;
}

sub Param {
    my ( $Self, %Param ) = @_;

    # check if we need to show password change option

    # define AuthModule for frontend
    my $AuthModule = $Self->{ConfigItem}->{Area} eq 'Agent'
        ? 'AuthModule'
        : 'Customer::AuthModule';

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # get auth module
    my $Module      = $ConfigObject->Get($AuthModule);
    my $AuthBackend = $Param{UserData}->{UserAuthBackend};
    if ($AuthBackend) {
        $Module = $ConfigObject->Get( $AuthModule . $AuthBackend );
    }

    # return on no pw reset backends
    return if $Module =~ /(LDAP|HTTPBasicAuth|Radius)/i;
	
    my @Params;
    push(
        @Params,
        {
            %Param,
            Key   => Translatable('First Name'),
            Name  => 'FN',
            Raw   => 1,
			#Input for text field, Option for dropdown
            Block => 'Input',
			SelectedID => $Param{UserData}->{UserFirstname},
        },
         {
            %Param,
            Key   => Translatable('Last Name'),
            Name  => 'LN',
            Raw   => 1,
			#Input for text field, Option for dropdown
            Block => 'Input',
			SelectedID => $Param{UserData}->{UserLastname},
        },
        {
            %Param,
            Key   => Translatable('Mobile'),
            Name  => 'Mobile',
            Raw   => 1,
			#Input for text field, Option for dropdown
            Block => 'Input',
			SelectedID => $Param{UserData}->{UserMobile},
        },
    );

    return @Params;
}

sub Run {
    my ( $Self, %Param ) = @_;
    
	my $ConfigObject   = $Kernel::OM->Get('Kernel::Config');
    my $LanguageObject = $Kernel::OM->Get('Kernel::Language');
	
	my $FN;
    if ( $Param{GetParam}->{FN} && $Param{GetParam}->{FN}->[0] ) {
        $FN = $Param{GetParam}->{FN}->[0];
    }
    my $LN;
    if ( $Param{GetParam}->{LN} && $Param{GetParam}->{LN}->[0] ) {
        $LN = $Param{GetParam}->{LN}->[0];
    }
	
	my $Mobile;
    if ( $Param{GetParam}->{Mobile} && $Param{GetParam}->{Mobile}->[0] ) {
        $Mobile = $Param{GetParam}->{Mobile}->[0];
    }
        
	# define AuthModule for frontend
    my $AuthModule = $Self->{ConfigItem}->{Area} eq 'Agent'
        ? 'Auth'
        : 'CustomerAuth';

    my $AuthObject = $Kernel::OM->Get( 'Kernel::System::' . $AuthModule );
    return 1 if !$AuthObject;
	
	my $CustomerUserObject = $Kernel::OM->Get('Kernel::System::CustomerUser');
	$CustomerUserObject->CustomerUserUpdate(
        Source        => 'CustomerUser', # CustomerUser source config
        ID            => $Param{UserData}->{UserLogin},            # current user login
        UserLogin     => $Param{UserData}->{UserLogin},       # new user login
		UserCustomerID => $Param{UserData}->{UserCustomerID},
		UserFirstname => $FN,
        UserLastname  => $LN,
		UserMobile	=> $Mobile,
		UserEmail     => $Param{UserData}->{UserEmail},
        ValidID       => 1,
        UserID        => 1,
    );
	
	
	
    $Self->{Message} = Translatable('Profile updated successfully!');
    return 1;
}

sub Error {
    my ( $Self, %Param ) = @_;

    return $Self->{Error} || '';
}

sub Message {
    my ( $Self, %Param ) = @_;

    return $Self->{Message} || '';
}

1;

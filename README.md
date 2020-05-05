# OTRS Customer Self Profile Update
- Built for OTRS CE 6.0.x
- Allow customer user to update their profile like name, mobile number at customer portal.
- By default, customer only can update their password, language, timezone, etc.

1. Required to modify Custom/Kernel/Module/AdminCustomerUser.pm


        next GROUP if $Group eq 'Password';
    (+) next GROUP if $Group eq 'CustomerProfile';
    
    
        next GROUP if $Group eq 'Password';
    (+) next GROUP if $Group eq 'CustomerProfile';
    
    
        if ( $Group eq 'Password' ) {
            next PRIO;
        }
    (+) if ( $Group eq 'CustomerProfile' ) {
    (+) 	next PRIO;
    (+) }
    
[![profile.png](https://i.postimg.cc/MHw2bjsD/profile.png)](https://postimg.cc/LYxbmhFY)
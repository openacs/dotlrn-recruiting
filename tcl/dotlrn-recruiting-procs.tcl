#
#  Copyright (C) 2001, 2002 OpenForce
#
#  This file is part of this.
#
#  this is free software; you can redistribute it and/or modify it under the
#  terms of the GNU General Public License as published by the Free Software
#  Foundation; either version 2 of the License, or (at your option) any later
#  version.
#
#  this is distributed in the hope that it will be useful, but WITHOUT ANY
#  WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
#  FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
#  details.
#
#

ad_library {

    Procs to set up the this Recruiting applet

    @author chak (chak@openforce.net)
    @author Arjun Sanyal (arjun@openforce.net)
 
    @version $Id$

}

namespace eval dotlrn_recruiting {

    ad_proc -public applet_key {
    } {
        What's my applet key?
    } {
        return dotlrn_recruiting
    }

    ad_proc -public my_package_key {
    } {
        What's my package key?
    } {
        return "dotlrn-recruiting"
    }

    ad_proc -public package_key {
    } {
        What package does this applet deal with?
    } {
        return recruiting
    }

    ad_proc -public get_pretty_name {
    } {
        return the pretty name of this applet.
    } {
        return Recruiting
    }

    ad_proc -public add_applet {
    } {
        Add the recruiting applet to dotlrn - for one-time init
        Must be repeatable!
    } {
        if {![dotlrn_applet::applet_exists_p -applet_key [applet_key]]} {

            dotlrn_applet::add_applet_to_dotlrn \
                    -applet_key [applet_key] \
                    -package_key [my_package_key]
            
        }
    }

    ad_proc -public remove_applet {
    } {
        remove the applet from dotlrn
    } {
        ad_return_complaint 1 "[applet_key] remove_applet not implemented!"
    }

    ad_proc -public add_applet_to_community {
        community_id
    } {
        Add the recruiting applet to a dotlrn community
    } {
        # Create and Mount the recruiting package
        set package_id [dotlrn::instantiate_and_mount \
            -mount_point recruiting \
            $community_id \
            [package_key] \
        ]

        # mount attachments under recruiting, if available
        # attachments requires that dotlrn-fs is already mounted
        if {[apm_package_registered_p attachments] && [dotlrn_community::applet_active_p -community_id $community_id -applet_key [dotlrn_fs::applet_key]]} {

            set attachments_node_id [site_node::new \
                -name [attachments::get_url] \
                -parent_id [site_node::get_node_id_from_object_id -object_id $package_id]
            ]

            site_node::mount \
                -node_id $attachments_node_id \
                -object_id [apm_package_id_from_key attachments]

            set fs_package_id [dotlrn_community::get_applet_package_id \
                 -community_id $community_id \
                 -applet_key [dotlrn_fs::applet_key] \
            ]

            # map the fs root folder to the package_id of the new recruiting pkg
            attachments::map_root_folder \
                -package_id $package_id \
                -folder_id [fs::get_root_folder -package_id $fs_package_id]

        }

        # Set up permissions for basic members (Admins inherit no problem)
        set members [dotlrn_community::get_rel_segment_id \
            -community_id $community_id \
            -rel_type dotlrn_member_rel \
        ]

        # community admin should have admin in recruiting/admin.  how to do this?
        # beats me. -dc

        # set up the admin portlet
        set admin_portal_id [dotlrn_community::get_admin_portal_id \
            -community_id $community_id \
        ]

        recruiting_admin_portlet::add_self_to_page \
            -portal_id $admin_portal_id \
            -package_id $package_id

        # set up the portlet for this community
        set portal_id [dotlrn_community::get_portal_id \
            -community_id $community_id \
        ]

        # add the portlet to the comm's portal using add_portlet_helper
        set args [ns_set create]
        ns_set put $args package_id $package_id
        ns_set put $args param_action overwrite

        dotlrn_recruiting::add_portlet_helper $portal_id $args

        return $package_id
    }

    ad_proc -public remove_applet_from_community {
        community_id
    } {
        remove the applet from the given community
    } {
        ad_return_complaint 1 "[applet_key] remove_applet_from_community not implemented!"
    }

    ad_proc -public add_user {
        user_id
    } {
        Called when the user is initially added as a dotlrn user.
        For one-time init stuff.
    } {
    }

    ad_proc -public remove_user {
        user_id
    } {
        called when a user is removed from dotlrn.
    } {
    }

    ad_proc -public add_user_to_community {
        community_id
        user_id
    } {
        Add a user to a specific dotlrn community
    } {
        set portal_id [dotlrn::get_portal_id -user_id $user_id]
        set package_id [dotlrn_community::get_applet_package_id \
            -community_id $community_id \
            -applet_key [applet_key] \
        ]
        set args [ns_set create]
        ns_set put $args package_id $package_id
        ns_set put $args param_action append

        # don't use the cached version
        dotlrn_recruiting::add_portlet_helper \
            [dotlrn::get_portal_id_not_cached -user_id $user_id] \
            $args

        dotlrn_recruiting::add_portlet_helper $portal_id $args

    }

    ad_proc -public remove_user_from_community {
        community_id
        user_id
    } {
        Remove a user from a community
    } {
        set portal_id [dotlrn::get_portal_id -user_id $user_id]
        set package_id [dotlrn_community::get_applet_package_id \
            -community_id $community_id \
            -applet_key [applet_key] \
        ]

        set args [ns_set create]
        ns_set put $args package_id $package_id

        remove_portlet $portal_id $args

    }

    ad_proc -public add_portlet {
        portal_id
    } {
        A helper proc to set up default params for templates.

        @param portal_id
    } {
        set args [ns_set create]
        ns_set put $args package_id 0
        ns_set put $args display_group_name_p f
        ns_set put $args param_action overwrite

        set type [dotlrn::get_type_from_portal_id -portal_id $portal_id]

        if {[string equal $type user]} {
            # portal_id is a user portal template
            ns_set put $args display_group_name_p t
        }

        add_portlet_helper $portal_id $args
    }

    ad_proc -public add_portlet_helper {
        portal_id
        args
    } {
        This does the call to add the portlet to the given portal.
        Params for the portlet are set by the calllers.

        @param portal_id
        @param args An ns_set of params
    } {
        recruiting_portlet::add_self_to_page \
            -portal_id $portal_id \
            -package_id [ns_set get $args package_id] \
            -param_action [ns_set get $args param_action] \
            -display_group_name_p [ns_set get $args display_group_name_p]
    }

    ad_proc -public remove_portlet {
        portal_id
        args
    } {
        A helper proc to remove the underlying portlet from the given portal.

        @param portal_id
        @param args An ns_set of args
    } {
        set package_id [ns_set get $args package_id]
        recruiting_portlet::remove_self_from_page $portal_id $package_id
    }

    ad_proc -public clone {
        old_community_id
        new_community_id
    } {
        Clone this applet's content from the old community to the new one
    } {
        dotlrn_recruiting::add_applet_to_community $new_community_id
    }

    ad_proc -public change_event_handler {
        community_id
        event
        old_value
        new_value
    } { 
        listens for the following events: rename
    } { 
        switch $event {
        }
    }   

}

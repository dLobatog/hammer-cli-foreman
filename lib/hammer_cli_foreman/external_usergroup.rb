require 'hammer_cli_foreman/usergroup'

module HammerCLIForeman
  class ExternalUsergroup < HammerCLIForeman::Command
    resource :external_usergroups
    command_name 'external_usergroup'
    desc _("View and manage user group's external user groups")

    module UsergroupOptions
      def self.included(base)
        base.build_options
        base.validate_options do
          any(:option_usergroup_id, :option_usergroup_name).required
        end
      end
    end

    class ListCommand < HammerCLIForeman::ListCommand
      include HammerCLIForeman::ExternalUsergroup::UsergroupOptions

      output do
        field :id, _("Id")
        field :name, _("Name")
        field :auth_source_ldap, _("Auth source"), Fields::Reference
      end
    end

    class InfoCommand < HammerCLIForeman::InfoCommand
      include HammerCLIForeman::ExternalUsergroup::UsergroupOptions

      output ListCommand.output_definition do
        HammerCLIForeman::References.timestamps(self)
      end
    end

    class RefreshExternalUsergroupsCommand < HammerCLIForeman::ListCommand
      action :refresh
      command_name 'refresh'
      desc _("Refresh external user group")

      include HammerCLIForeman::ExternalUsergroup::UsergroupOptions

      output do
        field :name,        _("Name")
        field :auth_source_ldap, _("Auth source")
      end
    end


    class CreateCommand < HammerCLIForeman::CreateCommand

      include HammerCLIForeman::ExternalUsergroup::UsergroupOptions

      success_message _("External user group created")
      failure_message _("Could not create external user group")
    end


    class UpdateCommand < HammerCLIForeman::UpdateCommand

      include HammerCLIForeman::ExternalUsergroup::UsergroupOptions

      success_message _("External user group updated")
      failure_message _("Could not update external user group")
    end


    class DeleteCommand < HammerCLIForeman::DeleteCommand

      include HammerCLIForeman::ExternalUsergroup::UsergroupOptions

      success_message _("External user group deleted")
      failure_message _("Could not delete the external user group")
    end

    autoload_subcommands
  end

end


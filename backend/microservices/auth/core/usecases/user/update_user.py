from core.entities import edit_user
from .. import get_user


def build_update_user(update_user):
    def update_user(id = None, first_name = None,  last_name = None, email = None, password = None,
                    phone = None, profile_picture_url = None, birthday = None, gender = None) -> bool:
        if not id and not email:
            # TODO: throw error
            pass

        old_user = get_user(id=id) if id else get_user(email=email)
        if not old_user:
            # TODO: throw error
            pass

        edited_user = edit_user(
                    id= old_user.id,
                    first_name= first_name if first_name else old_user.first_name,
                    last_name= last_name if last_name else old_user.last_name,
                    email= email if email else old_user.email,
                    password= password if password else old_user.password,
                    phone= phone if phone else old_user.phone,
                    profile_picture_url= profile_picture_url if profile_picture_url else old_user.profile_picture_url,
                    birthday= birthday if birthday else old_user.birthday,
                    gender= gender if gender else old_user.gender,
                    new_email= email is not None,
                    new_phone= phone is not None,
                    new_gender= gender is not  None,
                    new_birthday= birthday is not None,
                    new_password= password is not None,
                    new_last_name= last_name is not None,
                    new_first_name= first_name is not None,
                    new_profile_picture_url= profile_picture_url is not None
                )

        return update_user(edited_user)
    return update_user

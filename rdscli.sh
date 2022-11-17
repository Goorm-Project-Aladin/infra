#!/bin/bash

up() {
    echo 'rds create-db-instance'

    # describe-db-instances check
    db_instance_check
    echo count $is_db_existence
    if [ $is_db_existence -ne 0 ]
    then
        echo 'is db-instance(book-db-mysql)'
        unset db_existence
        return
    fi
    unset db_existence

    # aws rds create-db
    aws rds create-db-instance \
        --engine mysql \
        --engine-version 8.0.28 \
        --multi-az \
        --db-instance-identifier book-db-mysql \
        --master-username admin \
        --master-user-password mysqladmin \
        --db-instance-class db.t3.micro \
        --storage-type gp2 \
        --allocated-storage 20 \
        --max-allocated-storage 1000 \
        --db-subnet-group-name eks-rds-subnet-group \
        --no-publicly-accessible \
        --vpc-security-group-ids "sg-0f2aadf47f2de15f5" \
        --backup-retention-period 7 \
        --preferred-backup-window 02:00-03:00 \
        --no-auto-minor-version-upgrade \
        --port 3306 \
        --deletion-protection \
        --db-name book \
    > ~/rds-info.txt
    
    cat ~/rds-info.txt
}

down() {
    echo 'rds delete-db-instance'

    # is db-instance?
    db_instance_check
    echo count $is_db_existence
    if [ $is_db_existence -eq 0 ]
    then
        echo 'no db-instance(book-db-mysql)'
        unset db_existence
        return
    fi
    unset db_existence

    # really deleted?
    echo 'are you sure you want to delete?? [y/n]'
    read input

    if [ $input == 'y' ]
    then
        # cancel deletion protection
        aws rds modify-db-instance \
            --db-instance-identifier book-db-mysql \
            --no-deletion-protection \
            --apply-immediately
    elif [ $input == 'n' ]
    then
        echo 'rds delete-db-instance cancel'
        return
    else
        echo 'command does not exist'
        echo 'rds delete-db-instance fail'
        return
    fi

    # rds delete-db-instance
    aws rds delete-db-instance \
        --db-instance-identifier book-db-mysql \
        --skip-final-snapshot \
        --no-delete-automated-backups
}

status() {
    echo 'rds db-instance describe'
    aws rds describe-db-instances \
        --query "*[].[DBInstanceIdentifier,Endpoint.Address,Endpoint.Port,MasterUsername]"
}

db_instance_check() {
    echo 'book-db-check'

    # db_existence
    
    local db_existence=$(aws rds describe-db-instances \
        --query "*[].[DBInstanceIdentifier,Endpoint.Address,Endpoint.Port,MasterUsername]" \
        | grep 'book-db-mysql')
 
    is_db_existence=${#db_existence}
}

rds_select() {
    input_str=${1}

    # input check
    if [ -z ${input_str} ]
    then
        echo 'please enter the command'
        return
    fi

    echo input : ${input_str}

    # command check
    if [ ${input_str} == 'up' ]
    then
        up
    elif [ ${input_str} == 'down' ]
    then
        down
    elif [ ${input_str} == 'status' ]
    then
        status
    elif [ ${input_str} == 'check' ]
    then
        db_instance_check
    else
        echo 'command does not exist'
    fi
    
}

rds_select $1
